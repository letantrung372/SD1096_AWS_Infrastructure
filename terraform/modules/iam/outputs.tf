output "cluster_role_arn" {
  description = "ARN of the cluster IAM role"
  value       = aws_iam_role.cluster_role.arn
}

output "node_role_arn" {
  description = "ARN of the node IAM role"
  value       = aws_iam_role.node_role.arn
}