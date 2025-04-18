provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr
}

module "security_groups" {
  source = "modules/security_groups"

  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "modules/ec2"

  vpc_id          = module.vpc.vpc_id
  security_group_id = module.security_groups.security_group_id
  instance_type   = var.instance_type
  ami             = var.ami
}