variable "Region" { # Local variable
    type = string
    description = "Region"
    default = "eu-central-1"
}

variable "instance_count" {
  description = "Количество запускаемых инстансов"
  type        = number
  default     = 1
}

variable "instance_tag" {
  description = "Тег для назначения инстансам"
  type        = string
  default     = "Non_Tag"
}
