

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
#--------------local vars-----------------
locals{
  vps_id = data.terraform_remote_state.backend_outputs.outputs.vpc_id
} 
*/
#------------------------------------------------------------

variable "vpc_id" {
  description = "ID of the VPC"
}

resource "aws_security_group" "SG" {
  name        = "${var.Name}}"
  description = "${var.description}"
  vpc_id      = "${local.vps_id}"
  tags = {
    Name = "${var.Tags}"
  }
  
  dynamic "ingress" {
    for_each = ["22", "8080"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

