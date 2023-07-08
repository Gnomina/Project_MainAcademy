#--------------Instanse main.tf-----------------


data "aws_ami" "latest_ubuntu" { # search ubuntu image in AWS
    owners =["099720109477"]
    most_recent = true
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-*"]
    }
}

resource "aws_instance" "example"{
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${var.sucurity_group}"]
  subnet_id              = "${var.subnet_id}"
  associate_public_ip_address = true
  iam_instance_profile = "EC2_RoleAddPerm"
  tags = {
    //"Name" = "${var.instance_tag}"
    "env"  = "${var.tags["Env"]}"
    "name" = "${var.tags["Name"]}"
  }
  
  //user code here.
  user_data = <<-EOF
  #!/bin/bash

    check_dependencies() {
      # Проверяем доступность AWS CLI
      aws --version >/dev/null 2>&1
      local aws_status=$?

      # Проверяем доступность Docker
      docker --version >/dev/null 2>&1
      local docker_status=$?

      # Возвращаем статусы проверки
      return $((aws_status + docker_status))
    }

    wait_for_dependencies() {
      local max_attempts=5
      local sleep_duration=60
      local attempt=1

      while ! check_dependencies; do
        echo "Ожидание доступности зависимостей (попытка $attempt/$max_attempts)..."
        sleep "$sleep_duration"

        attempt=$((attempt + 1))

        if ((attempt > max_attempts)); then
          echo "Ошибка: зависимости не доступны после нескольких попыток. Прерывание выполнения."
          exit 1
        fi
      done
    }
    wait_for_dependencies
    
    aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 284532103653.dkr.ecr.eu-central-1.amazonaws.com
    docker pull 284532103653.dkr.ecr.eu-central-1.amazonaws.com/mainacademy_images:WebApp
    docker run -d -p 49160:8080 --log-driver=awslogs --log-opt awslogs-group=MainAcademy_container_logs --log-opt awslogs-region=eu-central-1 --log-opt awslogs-stream=test_log 284532103653.dkr.ecr.eu-central-1.amazonaws.com/mainacademy_images:WebApp

    
  EOF
}
