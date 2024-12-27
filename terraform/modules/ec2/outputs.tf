output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.main.public_ip
}

output "public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.main.public_dns
}