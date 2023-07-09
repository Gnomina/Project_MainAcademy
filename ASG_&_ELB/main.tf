provider "aws" {
  region = "${var.Region}" 
}

# Создание шаблона запуска
resource "aws_launch_template" "example" {
  name_prefix   = "example"
  image_id      = var.ami_id #ami_id from block Create ami.
  instance_type = "t2.small"

  # Определение блока Network Interfaces, если требуется
  network_interfaces {
    device_index         = 0
    #associate_public_ip_address = true  # Установите значение в true, если требуется публичный IP
    subnet_id            = var.subnet_id  # Укажите подсеть, в которой должны размещаться экземпляры
    security_groups      = [var.sg_id]  # Укажите группы безопасности для экземпляров
  }
}

# Создание группы автомасштабирования (ASG) с использованием шаблона запуска
resource "aws_autoscaling_group" "example_asg" {
  name                 = "TEST-asg"
  min_size             = 3
  max_size             = 3
  desired_capacity     = 3
  launch_template {
    id      = aws_launch_template.example.id  # Используйте ID шаблона запуска
    version = "$Latest"  # Используйте последнюю версию шаблона
  }

  # Укажите ID или имя виртуальной частной сети (VPC) для размещения ASG
  vpc_zone_identifier = [ var.vpc_id, ]

  # Укажите имя подсетей для размещения экземпляров EC2
  subnet_names         = [var.subnet_name, ]

  # Укажите имя группы безопасности для экземпляров EC2
  security_groups      = [var.sg_id]
}

# Создание Application Load Balancer (ALB)
resource "aws_lb" "example_alb" {
  name               = "TEST-alb"
  load_balancer_type = "application"
  subnets            = [var.subnet_name,]  # Укажите подсети для размещения ALB

  # Определение проверки здоровья
  enable_deletion_protection = false
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200"
  }
}

# Создание таргет-группы для ALB
resource "aws_lb_target_group" "example_target_group" {
  name     = "TEST-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id  # Укажите ID или имя VPC
}

# Привязка ASG к ALB
resource "aws_lb_target_group_attachment" "example_attachment" {
  target_group_arn = aws_lb_target_group.example_target_group.arn
  target_id        = aws_autoscaling_group.example_asg.id
  port             = 80
}




