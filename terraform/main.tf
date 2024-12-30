# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  environment    = var.environment
  vpc_cidr      = var.vpc_cidr
  azs           = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "iam" {
  source = "./modules/iam"

  environment = var.environment
}

module "security_groups" {
  source = "./modules/security_groups"

  environment = var.environment
  vpc_id     = module.vpc.vpc_id
}

module "ecr" {
  source = "./modules/ecr"

  environment = var.environment
}

module "eks" {
  source = "./modules/eks"

  environment     = var.environment
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnet_ids
  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn    = module.iam.eks_node_role_arn
}

module "ec2" {
  source = "./modules/ec2"

  environment    = var.environment
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = module.vpc.private_subnet_ids
  instance_profile = module.iam.ec2_instance_profile_name
  security_group_ids = [module.security_groups.ec2_sg_id]
}