
#----------------Instance Variables----------------

variable "instance_type"{
  default     = "t2.small" # Local variable
    description = "(Free tire eligible t2micro) t2.small instance"
}

variable "key_name"{
  default     = "ubuntu_key" # Local variable
    description = "SSH key for instance"
}

variable "sucurity_group" { # variable from  SG module -> outputs
  description = "local value of the 'security_group_id' variable from the SG module -> outputs"
}
variable "subnet_id"  { # variable from  VPC module -> outputs
  description = "local value of the 'subnet_id_out' variable from the VPC module -> outputs"
}

variable tags {
  type = map(string)
  default = {
    Name = "Test_Stack"
  }
}

variable "instance_tag" {
  description = "instance tag"
  type        = string
  default     = "Stack_ami_image"
}