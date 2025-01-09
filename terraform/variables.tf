# variables.tf
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "eks_instance_types" {
  description = "List of instance types for EKS nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_desired_size" {
  description = "Desired size of EKS node group"
  type        = number
  default     = 2
}

variable "eks_min_size" {
  description = "Minimum size of EKS node group"
  type        = number
  default     = 1
}

variable "eks_max_size" {
  description = "Maximum size of EKS node group"
  type        = number
  default     = 4
}

variable "bastion_ami_id" {
  description = "AMI ID for bastion host"
  type        = string
  default     = "ami-0f935a2ecd3a7bd5c"
}

variable "bastion_instance_type" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t3.medium"
}

variable "ssh_key_name" {
  description = "Name of SSH key pair"
  type        = string
  default     = "ec2-keypair"
}