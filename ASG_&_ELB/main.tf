provider "aws" {
  region = "${var.Region}" 
}
#------------------------------------------------------------------------------
# Создание шаблона запуска
resource "aws_launch_configuration" "example" {
  name_prefix   = "example"
  image_id      = "ami-0b6777e145afb9a29" #ami_id from block Create ami.
  instance_type = "t2.small"
  
  security_groups = ["${sg_id}"]

  user_data = <<-EOF
  #!/bin/bash

    check_dependencies() {
      # Chec if AWS CLI are available
      aws --version >/dev/null 2>&1
      local aws_status=$?

      # Check if Docker are available
      docker --version >/dev/null 2>&1
      local docker_status=$?

      # Return status AWS CLI and Docker
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
          echo "Error: Dependencies not available after several attempts. Execution interrupt."
          exit 1
        fi
      done
    }
    wait_for_dependencies
    
    aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 284532103653.dkr.ecr.eu-central-1.amazonaws.com
    docker pull 284532103653.dkr.ecr.eu-central-1.amazonaws.com/mainacademy_images:WebApp
    
    if [[ ! -f "/home/ubuntu/nginx.conf" ]]; then
      echo "${file("nginx.conf")}" > /home/ubuntu/nginx.conf
    fi

    if [[ ! -f "/home/ubuntu/docker-compose.yml" ]]; then
      echo "${file("docker-compose.yml")}" > /home/ubuntu/docker-compose.yml
    fi

    docker-compose -f /home/ubuntu/docker-compose.yml up -d
  EOF
}#------------------------------------------------------------------------------




