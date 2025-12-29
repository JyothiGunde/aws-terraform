variable "project" {
  type = string
}

variable "ami" {
  type = string
}

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
