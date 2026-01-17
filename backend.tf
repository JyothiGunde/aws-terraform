terraform {
  backend "s3" {
    bucket = "terraform-github-actions-jyothi-gunde"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}