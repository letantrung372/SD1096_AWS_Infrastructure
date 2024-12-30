# modules/eks/variables.tf
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "ARN of the IAM role for the EKS cluster"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of the IAM role for the EKS nodes"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "node_group_desired_size" {
  description = "Desired number of nodes in the node group"
  type        = number
  default     = 2
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in the node group"
  type        = number
  default     = 4
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in the node group"
  type        = number
  default     = 1
}

variable "node_group_instance_types" {
  description = "List of instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "spot_node_group_desired_size" {
  description = "Desired number of nodes in the spot node group"
  type        = number
  default     = 1
}

variable "spot_node_group_max_size" {
  description = "Maximum number of nodes in the spot node group"
  type        = number
  default     = 2
}

variable "spot_node_group_min_size" {
  description = "Minimum number of nodes in the spot node group"
  type        = number
  default     = 1
}

variable "spot_node_group_instance_types" {
  description = "List of instance types for the spot node group"
  type        = list(string)
  default     = ["t3.small", "t3.medium"]
}