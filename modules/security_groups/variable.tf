variable "ports" {
  type    = set(string)
  default = [22, 80]
}

variable "cidr_block" {
  type    = string
}

variable "vpc_id" {
  type = string
}

locals {
  common_tags = {
    project = "demo"
  }
}