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
    
    #obtain ECR Credentials
    ECR_LOGIN=$(aws ecr get-login-password --region eu-central-1)
    echo $ECR_LOGIN | docker login --username AWS --password-stdin 284532103653.dkr.ecr.eu-central-1.amazonaws.com

    # Download container
    docker pull 284532103653.dkr.ecr.eu-central-1.amazonaws.com/mainacademy_images:WebApp
   
    echo "Finished user_data script"
  EOF
}
