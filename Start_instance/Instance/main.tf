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
    "Name" = "${var.instance_tag}"
    "env"  = var.instance_tag
  }
}
