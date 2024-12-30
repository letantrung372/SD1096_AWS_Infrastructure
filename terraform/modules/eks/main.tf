# modules/eks/main.tf
resource "aws_eks_cluster" "main" {
  name     = "${var.environment}-cluster"
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_public_access  = true
    endpoint_private_access = true
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = {
    Name        = "${var.environment}-cluster"
    Environment = var.environment
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.environment}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  update_config {
    max_unavailable = 1
  }

  instance_types = var.node_group_instance_types

  # Optional: Add labels to your nodes
  labels = {
    "environment" = var.environment
    "node-group"  = "main"
  }

  tags = {
    Name        = "${var.environment}-node-group"
    Environment = var.environment
  }

  # Optional: Add taints to your nodes
  taint {
    key    = "dedicated"
    value  = "main"
    effect = "NO_SCHEDULE"
  }
}

# Optional: Create additional node group for different workload types
resource "aws_eks_node_group" "spot" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.environment}-spot-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.spot_node_group_desired_size
    max_size     = var.spot_node_group_max_size
    min_size     = var.spot_node_group_min_size
  }

  update_config {
    max_unavailable = 1
  }

  instance_types = var.spot_node_group_instance_types
  capacity_type  = "SPOT"

  labels = {
    "environment" = var.environment
    "node-group"  = "spot"
  }

  tags = {
    Name        = "${var.environment}-spot-node-group"
    Environment = var.environment
  }
}