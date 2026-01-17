variable "vpc_id" {
  type = string
}

variable "public_subnets_id" {
  type = list(string)
}

variable "lb_sg" {
  type = set(string)
}

locals {
  common_tags = {
    project = "demo"
  }
}