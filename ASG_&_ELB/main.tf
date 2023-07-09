provider "aws" {
  region = "${var.Region}" 
}


resource "aws_network_interface" "example_nic" {
  subnet_id                = "subnet-0329c8ffd17751d83"
  security_groups          = ["sg-04947ae25e78b4864"]
  private_ips              = ["172.16.0.1"] # Замените на подходящий IP-адрес
}
#------------------------------------------------------------------------------
# Создание шаблона запуска
resource "aws_launch_template" "example" {
  name_prefix   = "example"
  image_id      = "ami-0b6777e145afb9a29" #ami_id from block Create ami.
  instance_type = "t2.small"
  key_name               = "ubuntu_key"
  vpc_security_group_ids = ["sg-04947ae25e78b4864"]
    
    
    network_interfaces {
      device_index          = 0
      network_interface_id  = aws_network_interface.example_nic.id  
      associate_public_ip_address = true
      //security_group_ids = ["sg-04947ae25e78b4864"]
      
    }
    
  
    iam_instance_profile {
      name = "EC2_RoleAddPerm"  
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


# Ассоциация таблицы маршрутизации с публичной подсетью
resource "aws_route_table_association" "subnet_association" {
  subnet_id         = "subnet-0329c8ffd17751d83"  # Замените на ID вашей публичной подсети
  route_table_id    = "rtb-029d3649c48c3d855"  # Замените на ID вашей таблицы маршрутизации
}


