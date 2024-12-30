output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ec2_test.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.ec2_test.public_ip
}

output "public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.ec2_test.public_dns
}