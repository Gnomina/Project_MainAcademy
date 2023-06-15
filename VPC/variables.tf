variable "VPC_cidr_block" {
  type = string
  default = "10.0.0.0/16"
    description = "value of VPC_cidr_block"
}

variable "subnet_cidr_block" {
  type = string
  default = "10.0.1.0/24"
    description = "value of subnet_cidr_block"
}

vaiable "Name_VPC" {
  type = string
  default = "MainAcademy_VPC"
    description = "Name of VPC"
}

vaiable "Name_subnet" {
  type = string
  default = "MainAcademy_Subnet"
    description = "Name of subnet"
}

vaiable "Name_InternetGateway" {
  type = string
  default = "MainAcademy_IGW_Net"
    description = "Name of InternetGateway"
}

vaiable "Name_RouteTable" {
  type = string
  default = "MainAcademy_RouteTable"
    description = "Name of RouteTable"
}

variable "route_destination_cidr_block" {
  type = string
  default = "0.0.0.0/0"
    description = "value of route_destination_cidr_block"
}