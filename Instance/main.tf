#-----------------Load Variables and other data from remote backend S3. This vars work only after create Infrastructure and save data on s3bucket----------------
data "terraform_remote_state" "backend_outputs" {
  backend = "s3"
  config = {
    bucket = "mainacademy-project-terraform-back"
    key    = "dev/backend/terraform.tfstate"
    region = "eu-central-1"
   }
}
/*
#- create local vars from s3 bucket, this vars work only after create Infrastructure and save data on s3bucket.----
locals{
  vps_id = data.terraform_remote_state.backend_outputs.outputs.vpc_id
} 

locals {
    sg_id = data.terraform_remote_state.backend_outputs.outputs.sg_id
}

locals {
    subnet_id = data.terraform_remote_state.backend_outputs.outputs.subnet_id
}
#------------------------------------------------------------------------------------
*/


/*
variable "branch_name" {
  description = "Branch name from Jenkins"
}
*/


data "aws_ami" "latest_ubuntu" {
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
  tags = {
    Name = "MainAcademy_Instance_TEST"
  }                  
}


