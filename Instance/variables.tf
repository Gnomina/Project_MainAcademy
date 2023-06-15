variable "ami_id"{
  default     = "ami-0d5095d28a904a729"
    description = "Canonical, Ubuntu, 20.04 LTS, amd64 focal image build on 2023-05-17"
}

variables "instance_type"{
  default     = "t2.micro"
    description = "Free tire eligible t2.mikro instance"
}

variable "key_name"{
  default     = "ubuntu_key"
    description = "SSH key for instance"
}