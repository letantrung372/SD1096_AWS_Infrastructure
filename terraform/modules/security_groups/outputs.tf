# modules/security_groups/outputs.tf
output "eks_cluster_sg_id" {
  description = "ID of EKS cluster security group"
  value       = aws_security_group.eks_cluster.id
}

output "eks_nodes_sg_id" {
  description = "ID of EKS nodes security group"
  value       = aws_security_group.eks_nodes.id
}

output "ec2_sg_id" {
  description = "ID of EC2 security group"
  value       = aws_security_group.ec2.id
}