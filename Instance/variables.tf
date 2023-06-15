
variable "instance_type"{
  default     = "t2.micro"
    description = "Free tire eligible t2.mikro instance"
}

variable "key_name"{
  default     = "ubuntu_key"
    description = "SSH key for instance"
}