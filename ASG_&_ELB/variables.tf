variable "Region" { # Local variable
    type = string
    description = "Region"
    default = "eu-central-1"
}
/*
variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}
*/

variable "subnet_id" {
  description = "Subnet ID for the EC2 instances"
  type        = string
}

variable "sg_id" {
  description = "Security Group ID for the EC2 instances"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the EC2 instances"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name for the EC2 instances"
  type        = string
}

