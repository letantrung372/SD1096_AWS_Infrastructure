output "jenkins_instance_id" {
  description = "The ID of the Jenkins EC2 instance"
  value       = aws_instance.jenkins.id
}

output "jenkins_public_ip" {
  description = "The public IP address of the Jenkins instance"
  value       = aws_instance.jenkins.public_ip
}

output "jenkins_private_ip" {
  description = "The private IP address of the Jenkins instance"
  value       = aws_instance.jenkins.private_ip
}

output "jenkins_security_group_id" {
  description = "The ID of the Jenkins security group"
  value       = aws_security_group.jenkins.id
}