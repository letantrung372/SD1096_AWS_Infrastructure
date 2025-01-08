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
  
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  project_name       = var.project_name
}

module "ecr" {
  source = "./modules/ecr"
  
  repository_names = ["frontend", "backend"]
}

module "eks" {
  source = "./modules/eks"
  
  cluster_name    = "${var.project_name}-cluster"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  node_group_name = "${var.project_name}-node-group"
}

module "ec2" {
  source = "./modules/ec2"
  
  instance_name    = "${var.project_name}-bastion"
  vpc_id           = module.vpc.vpc_id
  subnet_id        = module.vpc.public_subnet_ids[0]
  key_name         = var.key_name
  instance_type    = var.instance_type
}