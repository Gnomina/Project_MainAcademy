variable "region" {
  type        = string
  description = "Region to create resourses"
  default     = "eu-central-1"
}

variable "VPC-Name" {
  type        = string
  description = "VPC Name"
  default     = "MainAcademy_VPC"
}

variable "Subnet-Name" {
  type        = string
  description = "Subnet Name"
  default     = "MainAcademy_Subnet"
}

variable "IGW-Name" {
  type        = string
  description = "Internet Gateway Name"
  default     = "MainAcademy_IGW"
}

variable "RouteTable-Name" {
  type        = string
  description = "Route Table Name"
  default     = "MainAcademy_RouteTable"
}

variable "VPC-CIDR" {
  type        = string
  description = "VPC CIDR-Block"
  default     = "10.0.0.0/16"
  
}

variable "Subnet-CIDR" {
  type        = string
  description = "Subnet CIDR-Block"
  default     = "10.0.1.0/24"
}

variable "Destination-CIDR" {
  type        = string
  description = "Destination CIDR-Block"
  default     = "0.0.0.0/0"
}

variable "aws_vpc" {
  description = "AWS VPC"
  type        = object({
    my_vpc = object({
      id = string
    })
  })
}


# Path: Terraform\VPC\main.tf
