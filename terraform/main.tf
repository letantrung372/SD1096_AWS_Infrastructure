terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr            = var.vpc_cidr
  environment         = var.environment
  availability_zones  = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
}

module "eks" {
  source = "./modules/eks"
  
  cluster_name    = var.cluster_name
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnet_ids
  environment     = var.environment
}

module "ecr" {
  source = "./modules/ecr"
  
  repository_name = var.repository_name
  environment     = var.environment
}

module "security" {
  source = "./modules/security"
  
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
}

module "ec2" {
  source = "./modules/ec2"
  
  environment         = var.environment
  subnet_id          = module.vpc.subnet_id
  security_group_ids = [module.security.security_group_id]
  instance_type      = var.instance_type
  key_name           = var.key_name
  ami_id             = var.ami_id
  root_volume_size   = var.root_volume_size
}

# module "jenkins" {
#   source = "./modules/jenkins"
  
#   instance_type = var.jenkins_instance_type
#   subnet_id     = module.vpc.public_subnet_ids[0]
#   vpc_id        = module.vpc.vpc_id
#   environment   = var.environment
# }