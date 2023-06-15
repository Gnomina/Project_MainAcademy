variable "ami_id"{
  default     = "ami-043b07e04972f1afa"
    description = "Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-05-16"
}

variable "instance_type"{
  default     = "t2.micro"
    description = "Free tire eligible t2.mikro instance"
}

variable "key_name"{
  default     = "ubuntu_key"
    description = "SSH key for instance"
}