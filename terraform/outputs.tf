output "vpc_info" {
  description = "VPC Information"
  value = {
    vpc_id              = module.vpc.vpc_id
    vpc_cidr           = module.vpc.vpc_cidr
    public_subnet_ids  = module.vpc.public_subnet_ids
  }
}

output "eks_info" {
  description = "EKS Cluster Information"
  value = {
    cluster_name     = module.eks.cluster_name
    cluster_endpoint = module.eks.cluster_endpoint
    cluster_role_arn = module.eks.cluster_role_arn
  }
}

output "ecr_info" {
  description = "ECR Repository Information"
  value = {
    repository_url  = module.ecr.repository_url
    repository_name = module.ecr.repository_name
  }
}

output "jenkins_info" {
  description = "Jenkins Instance Information"
  value = {
    public_ip  = module.jenkins.jenkins_public_ip
    private_ip = module.jenkins.jenkins_private_ip
    instance_id = module.jenkins.jenkins_instance_id
  }
}