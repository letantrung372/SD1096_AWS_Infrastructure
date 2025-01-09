# modules/ec2/outputs.tf
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.bastion.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.bastion.public_ip
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.bastion.private_ip
}

output "instance_state" {
  description = "State of the EC2 instance"
  value       = aws_instance.bastion.instance_state
}

output "subnet_id" {
  description = "ID of the subnet where the instance is launched"
  value       = aws_instance.bastion.subnet_id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.bastion.arn
}

output "availability_zone" {
  description = "Availability zone of the EC2 instance"
  value       = aws_instance.bastion.availability_zone
}

output "key_name" {
  description = "Name of the key pair used for the instance"
  value       = aws_instance.bastion.key_name
}

# Add these outputs to the root outputs.tf file to expose EC2 informatio