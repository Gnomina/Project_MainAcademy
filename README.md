# Project_MainAcademy
Project at MainAcademy shcool
http://35.242.240.246:8080/

create ASG
https://www.youtube.com/watch?v=9Z0heLHN2Xk&ab_channel=e2eSolutionArchitect
https://github.com/e2eSolutionArchitect/terraform/tree/main/providers/aws/projects/e2esa-aws-ec2-autoscaling
https://www.youtube.com/watch?v=dI7d48UsVyc&ab_channel=S3CloudHub


stage('Create EC2 Instance') {
  steps {
    dir('create_instance') {
      // Кроки для запуску Terraform і створення EC2 інстансу
      sh 'terraform init'
      sh 'terraform apply -auto-approve'
    }
  }
}

stage('Run Ansible') {
  steps {
    dir('ansible') {
      // Кроки для підключення до EC2 інстансу і запуску Ansible-скриптів
      sh 'ansible-playbook playbook.yml -i inventory.ini'
    }
  }
}

stage('Create AMI') {
  steps {
    dir('create_ami') {
      // Кроки для запуску Terraform і створення AMI з налаштованого EC2 інстансу
      sh 'terraform init'
      sh 'terraform apply -auto-approve'
    }
  }
}
