
variable "instance_type" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets_id" {
  type = list(string)
}

variable "cidr_block" {
  type = string
}

variable "ports" {
  type    = set(string)
  default = [22, 80]
}

locals {
  common_tags = {
    project = "demo"
  }
}
