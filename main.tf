provider "aws" {
  region = "us-east-1"
}
module "vpc" {
  source = "./modules/vpc"

  project = "demo"

  vpc_cidr = "10.0.0.0/16"

  public_cidr = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  private_cidr = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

}

module "asg" {
  source = "./modules/asg"

  project = "demo"

  ami = "ami-068c0051b15cdb816"

  instance_type = "t2.nano"

  cidr_block = "0.0.0.0/0"

  vpc_id = module.vpc.vpc_id

  public_subnets_id = module.vpc.public_subnets_id

}