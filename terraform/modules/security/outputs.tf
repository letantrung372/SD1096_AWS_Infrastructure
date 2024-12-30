output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.ec2.id
}

output "private_key" {
  value       = tls_private_key.private_key.private_key_pem
  sensitive   = true
  description = "Save this private key securely!"
}