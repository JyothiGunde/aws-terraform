provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  public_cidr        = var.public_cidr
  private_cidr       = var.private_cidr
  availability_zones = var.availability_zones

}

module "asg" {
  source = "./modules/asg"
  instance_type     = var.instance_type
  cidr_block        = var.cidr_block
  vpc_id            = module.vpc.vpc_id
  public_subnets_id = module.vpc.public_subnets_id

}