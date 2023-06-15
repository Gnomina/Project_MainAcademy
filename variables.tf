variable "Region" {
    type = string
    description = "Region"
    default = "eu-central-1"
}

variable "VPC_Project_PATH"{
    type = string
    description = "Path to VPC module"
    default = "./VPC"
}