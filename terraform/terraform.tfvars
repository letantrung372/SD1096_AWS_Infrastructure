aws_region = "ap-southeast-1"
environment = "dev"
vpc_cidr = "10.0.0.0/16"
availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]
public_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
eks_instance_types = ["t3.medium"]
eks_desired_size = 2
eks_min_size = 1
eks_max_size = 4
bastion_ami_id = "ami-0f935a2ecd3a7bd5c"
bastion_instance_type = "t3.medium"
cluster_name = "practical-devops-eks"
ssh_key_name="ec2-keypair"