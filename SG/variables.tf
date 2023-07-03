#-------------Security Group Variables-----------------

variable "Name" { #local variable
  default     = "MAinAcademy_SG"
    description = "Name of the SG"
}

variable "description" { # local variable
  default     = "MainAcademy_SG"
    description = "Description of the SG"
}

variable "Tags" { # local variable
  default     = "MainAcademy_SG"
    description = "Tags of the SG"
}

variable "vpc_id" {
  description = "ID of the VPC from VPC module -> outputs"
}
