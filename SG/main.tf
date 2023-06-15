

#-----------------Load Variables and other data from remote backend S3----------------
data "terraform_remote_state" "backend_outputs" {
  backend = "s3"
  config = {
    bucket = "mainacademy-project-terraform-back"
    key    = "dev/backend/terraform.tfstate"
    region = "eu-central-1"
   }
}
#--------------local vars-----------------
locals{
  vps_id = data.terraform_remote_state.backend_outputs.outputs.vpc_id
} 
#------------------------------------------------------------

resource "aws_security_group" "SG" {
  name        = "TEST_SG_ADD"
  description = "Test SG"
  vpc_id      = "${local.vps_id}"
  tags = {
    Name = "TEST_SG_ADD_TAG"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

