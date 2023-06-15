
data "terraform_remote_state" "backend_outputs" {
  backend = "s3"
  config = {
    bucket = "mainacademy-project-terraform-back"
    key    = "dev/backend/terraform.tfstate"
    region = "eu-central-1"
   }
}




resource "aws_security_group" "my_security_group" {
  name        = "TEST_SG_ADD"
  description = "Test SG"
  vpc_id      = data.terraform_remote_state.backend_outputs.outputs.vpc_id
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

/*
output "backend_variables" {
    value = data.terraform_remote_state.backend_outputs.outputs
}
*/