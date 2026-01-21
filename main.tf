provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  public_cidr        = var.public_cidr
  private_cidr       = var.private_cidr
  availability_zones = var.availability_zones

}

module "asg" {
  source            = "./modules/asg"
  instance_type     = var.instance_type
  vpc_id            = module.vpc.vpc_id
  public_subnets_id = module.vpc.public_subnets_id
  lb_tg             = [module.lb.tg]
  instance_sg       = [module.sgs.instance-sg]
  iam_role = module.iam.iam_role
}

module "lb" {
  source            = "./modules/loadbalancer"
  public_subnets_id = module.vpc.public_subnets_id
  vpc_id            = module.vpc.vpc_id
  lb_sg             = [module.sgs.lb-sg]
}

module "sgs" {
  source     = "./modules/security_groups"
  cidr_block = var.cidr_block
  vpc_id     = module.vpc.vpc_id
}

module "sns" {
  source = "./modules/sns"
}

module "cloudwatchalarm" {
  source   = "./modules/cloudwatchalarm"
  asg_name = module.asg.asg_name
  sns      = [module.sns.sns]
}

module "iam" {
  source = "./modules/iam"
}