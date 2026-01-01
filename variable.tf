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

variable "instance_type" {
  type = string
}

variable "cidr_block" {
  type = string
}