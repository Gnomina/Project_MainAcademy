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
    associate_public_ip_address = true  # Установите значение в true, если требуется публичный IP
    subnet_id            = "subnet-12345678"  # Укажите подсеть, в которой должны размещаться экземпляры
    security_groups      = ["sg-12345678"]  # Укажите группы безопасности для экземпляров
  }
}

# Создание группы автомасштабирования (ASG) с использованием шаблона запуска
resource "aws_autoscaling_group" "example_asg" {
  name                 = "example-asg"
  min_size             = 3
  max_size             = 3
  desired_capacity     = 3
  launch_template {
    id      = aws_launch_template.example.id  # Используйте ID шаблона запуска
    version = "$Latest"  # Используйте последнюю версию шаблона
  }

  # Укажите ID или имя виртуальной частной сети (VPC) для размещения ASG
  vpc_zone_identifier = ["vpc-12345678", "vpc-87654321"]

  # Укажите имя подсетей для размещения экземпляров EC2
  subnet_names         = ["subnet-abcdef", "subnet-fedcba"]

  # Укажите имя группы безопасности для экземпляров EC2
  security_groups      = ["sg-12345678"]
}
