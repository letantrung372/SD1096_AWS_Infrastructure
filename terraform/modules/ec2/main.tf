resource "aws_instance" "ec2_test" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  # user_data = file("${path.module}/installation.sh")
  user_data = <<-EOF
              #!/bin/bash
              # install Jenkins
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

  tags = {
    Name = "${var.environment}-ec2"
  }
}