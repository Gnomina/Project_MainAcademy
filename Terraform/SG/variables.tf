variable "name" {
    type        = string
    description = "Security Group Name"
    default     = "MainAcademy_SecurityGroup"
  }

 variable  "description" {
    type        = string
    description = "Security Group Description"
    default     = "Security group allowing SSH and HTTP-8080 access"
  }

variable "vpc_id" {
    type        = string
    description = "VPC-ID"
  }

