# outputs.tf

# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "nat_gateway_ips" {
  description = "List of NAT Gateway public IPs"
  value       = module.vpc.nat_gateway_ips
}

# EKS Outputs
output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "eks_node_groups" {
  description = "Info about EKS node groups including autoscaling group names and instance types"
  value = {
    general = {
      asg_names      = module.eks.general_node_group_asg_names
      instance_types = module.eks.general_node_group_instance_types
    }
    memory_optimized = {
      asg_names      = module.eks.memory_node_group_asg_names
      instance_types = module.eks.memory_node_group_instance_types
    }
    spot = {
      asg_names      = module.eks.spot_node_group_asg_names
      instance_types = module.eks.spot_node_group_instance_types
    }
  }
}

output "eks_cluster_status" {
  description = "Status of the EKS cluster"
  value       = module.eks.cluster_status
}

output "eks_addon_versions" {
  description = "Versions of installed EKS addons"
  value = {
    vpc_cni     = module.eks.vpc_cni_version
    coredns     = module.eks.coredns_version
    kube_proxy  = module.eks.kube_proxy_version
  }
}

# EC2 Outputs
output "jenkins_instance_id" {
  description = "ID of the Jenkins EC2 instance"
  value       = module.ec2.jenkins_instance_id
}

output "jenkins_public_ip" {
  description = "Public IP of the Jenkins instance"
  value       = module.ec2.jenkins_public_ip
}

output "ec2_asg_name" {
  description = "Name of the EC2 Auto Scaling Group"
  value       = module.ec2.autoscaling_group_name
}

# ECR Outputs
output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  value       = module.ecr.repository_arn
}

# Security Groups Outputs
output "security_group_ids" {
  description = "Map of security group IDs"
  value = {
    eks_cluster = module.security_groups.eks_cluster_sg_id
    eks_nodes   = module.security_groups.eks_nodes_sg_id
    ec2         = module.security_groups.ec2_sg_id
  }
}

# IAM Outputs
output "iam_role_arns" {
  description = "Map of IAM role ARNs"
  value = {
    eks_cluster = module.iam.eks_cluster_role_arn
    eks_nodes   = module.iam.eks_node_role_arn
    ec2         = module.iam.ec2_role_arn
  }
}

# Monitoring-Specific Outputs
output "monitoring_info" {
  description = "Information needed for monitoring setup"
  value = {
    cluster = {
      name       = module.eks.cluster_name
      endpoint   = module.eks.cluster_endpoint
      region     = var.aws_region
      version    = module.eks.cluster_version
    }
    nodes = {
      total_nodes = {
        general          = module.eks.general_node_group_scaling_config
        memory_optimized = module.eks.memory_node_group_scaling_config
        spot            = module.eks.spot_node_group_scaling_config
      }
      node_groups = module.eks.all_node_groups_info
    }
    networking = {
      vpc_id            = module.vpc.vpc_id
      vpc_cidr          = module.vpc.vpc_cidr
      private_subnets   = module.vpc.private_subnet_ids
      public_subnets    = module.vpc.public_subnet_ids
      nat_gateways      = module.vpc.nat_gateway_ips
    }
    jenkins = {
      instance_id    = module.ec2.jenkins_instance_id
      public_ip      = module.ec2.jenkins_public_ip
      asg_name       = module.ec2.autoscaling_group_name
    }
    security = {
      security_groups = module.security_groups.all_security_group_ids
      iam_roles      = module.iam.all_iam_role_arns
    }
    containers = {
      ecr_repository = module.ecr.repository_url
      registry_id    = module.ecr.registry_id
    }
  }
}

# CloudWatch Dashboard
output "cloudwatch_dashboard_url" {
  description = "URL of the CloudWatch dashboard"
  value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${module.monitoring.dashboard_name}"
}

# Prometheus & Grafana
output "prometheus_endpoint" {
  description = "Endpoint for Prometheus (if enabled)"
  value       = try(module.eks.prometheus_endpoint, null)
}

output "grafana_endpoint" {
  description = "Endpoint for Grafana (if enabled)"
  value       = try(module.eks.grafana_endpoint, null)
}

# Alerts and Notifications
output "sns_topic_arn" {
  description = "ARN of the SNS topic for monitoring alerts"
  value       = try(module.monitoring.sns_topic_arn, null)
}

# Health Checks
output "health_check_endpoints" {
  description = "Endpoints for various health checks"
  value = {
    eks_cluster = "${module.eks.cluster_endpoint}/healthz"
    jenkins     = "http://${module.ec2.jenkins_public_ip}:8080/login"
  }
}

# Cost Information
output "cost_allocation_tags" {
  description = "Tags used for cost allocation"
  value = {
    Environment = var.environment
    Project     = var.project_name
    Cluster     = module.eks.cluster_name
  }
}