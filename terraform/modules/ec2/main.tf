resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
              sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
              sudo yum upgrade -y
              sudo dnf install java-17-amazon-corretto -y
              sudo yum install jenkins -y
              sudo systemctl enable jenkins

              # install docker
              sudo yum install docker -y
              sudo service docker start
              sudo usermod -a -G docker jenkins

              sudo systemctl start jenkins

              # install git
              sudo yum install git -y

              # install kubectl
              sudo curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.2/2024-11-15/bin/linux/amd64/kubectl
              sudo chmod +x kubectl
              sudo mv kubectl /usr/local/bin/
              EOF
  depends_on = [aws_security_group.jenkins_sg]
  tags = {
    Name = var.instance_name
  }
}

# Generate private key
resource "tls_private_key" "instance_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create local private key file
resource "local_file" "private_key" {
  content         = tls_private_key.instance_key.private_key_pem
  filename        = "${path.root}/${var.key_name}.pem"
  file_permission = "0400"
}

# Create AWS key pair
resource "aws_key_pair" "instance_key" {
  key_name   = var.key_name
  public_key = tls_private_key.instance_key.public_key_openssh

  tags = {
    Name = var.key_name
  }
}

# Security Group for EC2
resource "aws_security_group" "jenkins_sg" {
  name_prefix = "jenkins-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict to your IP range
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict to your IP range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}