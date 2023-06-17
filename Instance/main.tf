#ami-0ab1a82de7ca5889c

#-----------------Load Variables and other data from remote backend S3----------------
data "terraform_remote_state" "backend_outputs" {
  backend = "s3"
  config = {
    bucket = "mainacademy-project-terraform-back"
    key    = "dev/backend/terraform.tfstate"
    region = "eu-central-1"
   }
}
/*
#--------------local vars------------------------------------------------------------
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

variable "sucurity_group" {
  description = "Security group id"
}
variable "subnet_id"  {
  description = "Subnet id"
}


data "aws_ami" "latest_ubuntu" {
    owners =["099720109477"]
    most_recent = true
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-*"]
    }
}
/*
variable "branch_name" {
  description = "Branch name from Jenkins"
}
*/


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

/*
resource "null_resource" "save_instance_ip" {
  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > instance_public_ip.txt"
    }
}*/
