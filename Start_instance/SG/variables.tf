#-------------Security Group Variables-----------------

variable "Name" { #local variable
  default     = "MAinAcademy_STACK_SG"
    description = "Name of the SG"
}

variable "description" { # local variable
  default     = "SG for the STACK"
    description = "Description of the SG"
}

variable "Tags" { # local variable
  default     = "STACK_SG"
    description = "Tags of the SG"
}

variable "vpc_id" {
  description = "ID of the VPC from VPC module -> outputs"
}
