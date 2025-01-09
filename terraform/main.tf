# main.tf
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
#   required_version = ">= 1.0"
# }

provider "aws" {
  profile = "practical-devops-aws"
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr           = var.vpc_cidr
  environment        = var.environment
  availability_zones = var.availability_zones
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
}

module "ecr" {
  source = "./modules/ecr"
  
  environment = var.environment
  repositories = [
    "frontend",
    "backend"
  ]
}

module "eks" {
  source = "./modules/eks"
  
  cluster_name    = "${var.environment}-msa-cluster"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  node_group_name = "${var.environment}-msa-nodes"
  instance_types  = var.eks_instance_types
  desired_size    = var.eks_desired_size
  min_size        = var.eks_min_size
  max_size        = var.eks_max_size
}

module "ec2_bastion" {
  source = "./modules/ec2"
  
  instance_name   = "${var.environment}-bastion"
  ami_id          = var.bastion_ami_id
  instance_type   = var.bastion_instance_type
  subnet_id       = module.vpc.public_subnet_ids[0]
  vpc_id          = module.vpc.vpc_id
  key_name        = var.ssh_key_name
}