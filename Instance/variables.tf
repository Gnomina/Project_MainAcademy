
variable "instance_type"{
  default     = "t2.small"
    description = "(Free tire eligible t2micro) t2.small instance"
}

variable "key_name"{
  default     = "ubuntu_key"
    description = "SSH key for instance"
}