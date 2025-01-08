# # variables.tf
# variable "aws_region" {
#   description = "AWS region"
#   type        = string
#   default     = "ap-southeast-1"
# }

# variable "environment" {
#   description = "Environment name"
#   type        = string
#   default     = "dev"
# }

# variable "vpc_cidr" {
#   description = "CIDR block for VPC"
#   type        = string
#   default     = "10.0.0.0/16"
# }

# variable "azs" {
#   description = "Availability zones"
#   type        = list(string)
#   default     = ["ap-southeast-1a", "ap-southeast-1b"]
# }

# variable "public_subnets" {
#   description = "Public subnet CIDR blocks"
#   type        = list(string)
#   default     = ["10.0.1.0/24", "10.0.2.0/24"]
# }

# variable "private_subnets" {
#   description = "Private subnet CIDR blocks"
#   type        = list(string)
#   default     = ["10.0.3.0/24", "10.0.4.0/24"]
# }

# variables.tf
variable "aws_region" {
  description = "AWS region"
  default     = "ap-southeast-1"
}

variable "project_name" {
  description = "Name of the project"
  default     = "msa-app"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}