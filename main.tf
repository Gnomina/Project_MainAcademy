provider "aws" {
  region = "${var.Region}" 
}

module "VPC" {
  source = "${var.VPC_Project_PATH}"
}




