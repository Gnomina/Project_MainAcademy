provider "aws" {
  region = "${var.Region}" 
}
#------------------------------------------------------------------------------
# Создание шаблона запуска
resource "aws_launch_template" "example" {
  name_prefix   = "example"
  image_id      = "ami-0b6777e145afb9a29" #ami_id from block Create ami.
  instance_type = "t2.small"
  key_name               = "ubuntu_key"
  vpc_security_group_ids = ["sg-04947ae25e78b4864"]
  
  iam_instance_profile {
    name = "EC2_RoleAddPerm"  # Замените на имя или ARN вашей роли IAM
  }
  network_interfaces {
      device_index          = 0
      subnet_id             = "subnet-0329c8ffd17751d83"  # Замените на ID вашей публичной подсети
      associate_public_ip_address = true
    }

  user_data = filebase64("userdata.sh") 
}#------------------------------------------------------------------------------

# Создание группы автоматического масштабирования (ASG)
resource "aws_autoscaling_group" "example_asg" {
  name                      = "example-asg"
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 3
  health_check_type         = "EC2"
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }
  vpc_zone_identifier       = ["subnet-0329c8ffd17751d83"]
  termination_policies      = ["OldestInstance"]

  load_balancers = [
    aws_elb.example_elb.name  
  ]
}

# Создание балансировщика нагрузки (ELB)
resource "aws_elb" "example_elb" {
  name               = "example-elb"
  security_groups    = ["sg-04947ae25e78b4864"]
  subnets            = ["subnet-0329c8ffd17751d83"]
  //instances          = ["i-073d9b9afe2a100ef"]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

# Создание внешнего интернет-шлюза (EIGW)
resource "aws_internet_gateway" "example_igw" {
  vpc_id = "vpc-0a5859a6d6889753f"  # Замените на ID вашей VPC

  tags = {
    Name = "TEST-igw"
  }
}

# Привязка внешнего интернет-шлюза к VPC
resource "aws_vpc_attachment" "example_vpc_attachment" {
  vpc_id             = "vpc-0a5859a6d6889753f"  # Замените на ID вашей VPC
  internet_gateway_id = aws_internet_gateway.example_igw.id
}

resource "aws_route_table" "example_public_route_table" {
  vpc_id = "vpc-0a5859a6d6889753f"  # Замените на ID вашей VPC

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_eigw.example_eigw.id
  }

  tags = {
    Name = "example-public-route-table-ЕУЫЕ"
  }
}

resource "aws_route_table_association" "example_public_subnet_association" {
  subnet_id      = "subnet-0329c8ffd17751d83"  # Замените на ID вашей публичной подсети
  route_table_id = aws_route_table.example_public_route_table.id
}



