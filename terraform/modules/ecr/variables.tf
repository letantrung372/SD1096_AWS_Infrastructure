variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "practical-devops-ecr"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}