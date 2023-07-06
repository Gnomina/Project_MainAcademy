
#-------------VPC variables-----------------

variable "VPC_cidr_block" { # Local variable
  type = string
  default = "172.16.0.0/24"
    description = "value of VPC_cidr_block"
}

variable "subnet_cidr_block" { # Local variable
  type = string
  default = "172.16.0.0/26"
    description = "value of subnet_cidr_block"
}

variable "Name_VPC" { # Local variable
  type = string
  default = "MainAcademy_STACK_VPC"
    description = "Name of VPC"
}

variable "Name_subnet" { # Local variable
  type = string
  default = "MainAcademy_STACK_Subnet"
    description = "Name of subnet"
}

variable "Name_InternetGateway" { # Local variable
  type = string
  default = "MainAcademy_STACK_IGW"
    description = "Name of InternetGateway"
}

variable "Name_RouteTable" { # Local variable
  type = string
  default = "MainAcademy_STACK_RouteTable"
    description = "Name of RouteTable"
}

variable "route_destination_cidr_block" { # Local variable  
  type = string
  default = "0.0.0.0/0"
    description = "value of route_destination_cidr_block"
}