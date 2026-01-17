variable "sns" {
  type = set(string)
}

variable "asg_name" {
  type = string
}

locals {
  common_tags = {
    project = "demo"
  }
}