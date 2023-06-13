# AWS Init
provider "aws" {
  region = var.region 
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  #VPS CIDR-Block

  tags = {
    Name = "MyVPC_TesT" #VPC Name
  }
}


