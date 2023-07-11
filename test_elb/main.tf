provider "aws" {
  region = "eu-central-1" 
}
#------------------------------------------------------------------------

# -----------------------Create VPC--------------------------------------
resource "aws_vpc" "main" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Project = "TEST_STACK_0.1"
    Name    = "My TEST_STACK_0.1 VPC"
  }
}
#------------------------------------------------------------------------

#------------------------Create Subnet-----------------------------------
# Create Public Subnet1
resource "aws_subnet" "pub_sub1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
  tags = {
    Project = "TEST_STACK_0.1"
    Name    = "public_subnet1"

  }
}

# Create Public Subnet2
resource "aws_subnet" "pub_sub2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.2.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true
  tags = {
    Project = "TEST_STACK_0.1"
    Name    = "public_subnet2"
  }
}

# Create Private Subnet1
resource "aws_subnet" "prv_sub1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.3.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = false

  tags = {
    Project = "TEST_STACK_0.1"
    Name    = "private_subnet1"
  }
}

# Create Private Subnet2
resource "aws_subnet" "prv_sub2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.4.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = false

  tags = {
    Project = "TEST_STACK_0.1"
    Name    = "private_subnet2"
  }
}
#------------------------------------------------------------------------

#------------------------Create Internet Gateway-------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Project = "TEST_STACK_0.1"
    Name    = "internet gateway"
  }
}
#------------------------------------------------------------------------

#------------------------Create Public Route Table-----------------------
resource "aws_route_table" "pub_sub1_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Project = "TEST_STACK_0.1"
    Name    = "public subnet route table"
  }
}

# Create route table association of public subnet1

resource "aws_route_table_association" "internet_for_pub_sub1" {
  route_table_id = aws_route_table.pub_sub1_rt.id
  subnet_id      = aws_subnet.pub_sub1.id
}
# Create route table association of public subnet2

resource "aws_route_table_association" "internet_for_pub_sub2" {
  route_table_id = aws_route_table.pub_sub1_rt.id
  subnet_id      = aws_subnet.pub_sub2.id
}
#------------------------------------------------------------------------

#------------------------Craete EIP for NAT -----------------------------
# Create EIP for NAT GW1
resource "aws_eip" "eip_natgw1" {
  count = "1"
}

# Create NAT gateway1
resource "aws_nat_gateway" "natgateway_1" {
  count         = "1"
  allocation_id = aws_eip.eip_natgw1[count.index].id
  subnet_id     = aws_subnet.pub_sub1.id
}

# Create EIP for NAT GW2
resource "aws_eip" "eip_natgw2" {
  count = "1"
}

# Create NAT gateway2
resource "aws_nat_gateway" "natgateway_2" {
  count         = "1"
  allocation_id = aws_eip.eip_natgw2[count.index].id
  subnet_id     = aws_subnet.pub_sub2.id
}
#------------------------------------------------------------------------

#------------------------Create Private Route Table----------------------
resource "aws_route_table" "prv_sub1_rt" {
  count  = "1"
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_1[count.index].id
  }
  tags = {
    Project = "TEST_STACK_0.1"
    Name    = "private subnet1 route table"
  }
}

# Create route table association betn prv sub1 & NAT GW1
resource "aws_route_table_association" "pri_sub1_to_natgw1" {
  count          = "1"
  route_table_id = aws_route_table.prv_sub1_rt[count.index].id
  subnet_id      = aws_subnet.prv_sub1.id
}

# Create private route table for prv sub2
resource "aws_route_table" "prv_sub2_rt" {
  count  = "1"
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_2[count.index].id
  }
  tags = {
    Project = "TEST_STACK_0.1"
    Name    = "private subnet2 route table"
  }
}

# Create route table association betn prv sub2 & NAT GW2
resource "aws_route_table_association" "pri_sub2_to_natgw1" {
  count          = "1"
  route_table_id = aws_route_table.prv_sub2_rt[count.index].id
  subnet_id      = aws_subnet.prv_sub2.id
}
#------------------------------------------------------------------------

#------------------------Create Security Group---------------------------
# Create security group for load balancer
resource "aws_security_group" "elb_sg" {
  name        = "alb_sg"
  description = "SG for application load balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "SG for ALB"
    Project = "TEST_STACK_0.1"
  }
}

# Create security group for webserver
resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "SG for web server"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "SG for web"
    Project = "TEST_STACK_0.1"
  }
}
#------------------------------------------------------------------------

#------------------------Create Launch config ---------------------------
#Create Launch config
resource "aws_launch_configuration" "webserver-launch-config" {
  name_prefix     = "webserver-launch-config"
  image_id        = "ami-07fc206c57b925dbe"
  instance_type   = "t2.small"
  key_name        = "ubuntu_key"
  security_groups = ["${aws_security_group.webserver_sg.id}"]

  iam_instance_profile = "EC2_RoleAddPerm"
    
    
  user_data = filebase64("userdata.sh")
}
#------------------------------------------------------------------------

#------------------------Create Auto Scaling Group----------------------
# Create Auto Scaling Group
resource "aws_autoscaling_group" "Demo-ASG-tf" {
  name                 = "TEST_STACK_0.1-ASG-tf"
  desired_capacity     = 3
  max_size             = 4
  min_size             = 1
  force_delete         = true
  depends_on           = [aws_lb.ALB-tf]
  target_group_arns    = ["${aws_lb_target_group.TG-tf.arn}"]
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.webserver-launch-config.name
  vpc_zone_identifier  = ["${aws_subnet.prv_sub1.id}", "${aws_subnet.prv_sub2.id}"]

  tag {
    key                 = "Name"
    value               = "TEST_STACK_0.1-ASG-tf"
    propagate_at_launch = true
  }
}

# Create Target group
resource "aws_lb_target_group" "TG-tf" {
  name       = "TEST-STACK-TargetGroup-tf"
  depends_on = [aws_vpc.main]
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.main.id
    
  health_check {
    interval            = 30
    timeout             = 10
    protocol            = "TCP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
#------------------------------------------------------------------------

#------------------------Create Load Balancer---------------------------
# Create ALB
resource "aws_lb" "ALB-tf" {
  //name               = "TEST-STACK-ALG-tf"
  name               = "MAIN-Academy-stack"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = [aws_subnet.pub_sub1.id, aws_subnet.pub_sub2.id]

  tags = {
    name    = "TEST_STACK_0.1-AppLoadBalancer-tf"
    Project = "TEST_STACK_0.1"
  }
}

# Create ALB Listener 
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.ALB-tf.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG-tf.arn
  }
}
#------------------------------------------------------------------------

#------------------------DNS Name----------------------------------------
output "elb_dns_name" {
  value = aws_lb.ALB-tf.dns_name
}
#------------------------------------------------------------------------