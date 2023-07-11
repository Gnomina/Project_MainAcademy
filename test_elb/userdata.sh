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