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
    "Name" = "${var.tags["Name"]}"
    "env"  = "${var.tags["Env"]}"
    //"name" = "${var.tags["Name"]}"
  }
  
  //user code here.
  user_data = <<-EOF
    #!/bin/bash

    check_dependencies() {
      # Check if AWS CLI is available
      aws --version >/dev/null 2>&1
      local aws_status=$?

      # Check if Docker is available
      docker --version >/dev/null 2>&1
      local docker_status=$?

      # Return AWS CLI and Docker status
      return $((aws_status + docker_status))
    }

    wait_for_dependencies() {
      local max_attempts=7
      local sleep_duration=60
      local attempt=1

      while ! check_dependencies; do
        echo "Waiting for availability of dependencies (attempt $attempt/$max_attempts)..."
        sleep "$sleep_duration"

        attempt=$((attempt + 1))

        if ((attempt > max_attempts)); then
          echo "Error: Dependencies not available after several attempts. Execution interrupted."
          exit 1
        fi
      done
    }

    wait_for_dependencies

    # Load environment variables from .env file
    set -a
    . /home/ubuntu/.env
    set +a

    # Create and define IMAGE_NAME variable
    IMAGE_NAME=284532103653.dkr.ecr.eu-central-1.amazonaws.com/mainacademy_images:WebApp

    aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 284532103653.dkr.ecr.eu-central-1.amazonaws.com

    docker pull $IMAGE_NAME

    if [[ ! -f "/home/ubuntu/nginx.conf" ]]; then
      echo "${file("nginx.conf")}" > /home/ubuntu/nginx.conf
    fi

    if [[ ! -f "/home/ubuntu/docker-compose.yml" ]]; then
      echo "${file("docker-compose.yml")}" > /home/ubuntu/docker-compose.yml
    fi

    docker-compose -f /home/ubuntu/docker-compose.yml up -d

  EOF
}

// docker run -d -p 49160:8080 --log-driver=awslogs --log-opt awslogs-group=MainAcademy_container_logs --log-opt awslogs-region=eu-central-1
// --log-opt awslogs-stream=test_log 284532103653.dkr.ecr.eu-central-1.amazonaws.com/mainacademy_images:WebApp