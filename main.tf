terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
  # profile = "terraform-user"
}

module "vpc" {
  source          = "./modules/vpc"
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "sg" {
  source        = "./modules/security_groups"
  project_name  = var.project_name
  vpc_id        = module.vpc.vpc_id
  my_ip         = var.my_ip
}

module "ec2" {
  source             = "./modules/ec2"
  project_name       = var.project_name
  public_subnet_id   = element(module.vpc.public_subnets_id, 0)
  private_subnet_id  = element(module.vpc.private_subnets_id, 0)
  public_sg_id       = module.sg.public_sg_id
  private_sg_id      = module.sg.private_sg_id
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  key_name           = var.key_name
}
