variable "vpc_cidr" {
  type = string
}

variable "public_cidr" {
  type = list(any)
}

variable "private_cidr" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

locals {
  common_tags = {
    project = "demo"
  }
}