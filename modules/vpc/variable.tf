variable "region" {
   type = string
}

variable "project" {
  type = string
}

variable "vpc_cidr" {
    type = string
}

variable "public_cidr" {
    type = list
}

variable "private_cidr" {
    type = list(string)
}

variable "availability_zones" {
    type = list(string)
}