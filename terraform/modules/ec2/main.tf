# # modules/ec2/main.tf
# data "aws_ami" "amazon_linux_2" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   }
# }

# resource "aws_launch_template" "main" {
#   name_prefix   = "${var.environment}-template"
#   image_id      = data.aws_ami.amazon_linux_2.id
#   instance_type = var.instance_type

#   network_interfaces {
#     associate_public_ip_address = true  # Changed to true to access Jenkins
#     security_groups            = var.security_group_ids
#   }

#   iam_instance_profile {
#     name = var.instance_profile
#   }

#   user_data = base64encode(file("installation.sh"))

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name        = "${var.environment}-instance"
#       Environment = var.environment
#     }
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # Add new security group rule for Jenkins
# resource "aws_security_group_rule" "jenkins" {
#   type              = "ingress"
#   from_port         = 8080
#   to_port           = 8080
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]  # In production, restrict to specific IP ranges
#   security_group_id = var.security_group_ids[0]
# }

# resource "aws_autoscaling_group" "main" {
#   name                = "${var.environment}-asg"
#   desired_capacity    = var.asg_desired_capacity
#   max_size            = var.asg_max_size
#   min_size            = var.asg_min_size
#   target_group_arns   = var.target_group_arns
#   vpc_zone_identifier = var.subnet_ids

#   launch_template {
#     id      = aws_launch_template.main.id
#     version = "$Latest"
#   }

#   tag {
#     key                 = "Name"
#     value               = "${var.environment}-instance"
#     propagate_at_launch = true
#   }

#   tag {
#     key                 = "Environment"
#     value               = var.environment
#     propagate_at_launch = true
#   }
# }

# modules/ec2/main.tf
resource "aws_security_group" "bastion" {
  name        = "${var.instance_name}-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.instance_name}-sg"
  }
}

resource "aws_iam_role" "bastion" {
  name = "${var.instance_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_read" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.bastion.name
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.instance_name}-profile"
  role = aws_iam_role.bastion.name
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name              = var.key_name
  subnet_id             = var.subnet_id
  iam_instance_profile  = aws_iam_instance_profile.bastion.name
  security_groups       = [aws_security_group.bastion.id]

  user_data = <<-EOF
              sudo apt update
              sudo apt install openjdk-17-jre -y
              sudo apt install openjdk-17-jdk -y

              curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
              /usr/share/keyrings/jenkins-keyring.asc > /dev/null
              echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
              https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
              /etc/apt/sources.list.d/jenkins.list > /dev/null
              sudo apt-get update
              sudo apt-get install jenkins -y

              # Add Docker's official GPG key:
              sudo apt-get update
              sudo apt-get install ca-certificates curl gnupg
              sudo install -m 0755 -d /etc/apt/keyrings
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
              sudo chmod a+r /etc/apt/keyrings/docker.gpg

              # Add the repository to Apt sources:
              echo \
                "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
                "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
                sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              sudo apt-get update

              sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

              # Add Jenkins user into docker group
              sudo usermod -aG docker jenkins
              sudo usermod -aG docker $USER

              sudo apt-get install git-all

              # Debian/Ubuntu 
              sudo apt-get install wget apt-transport-https gnupg lsb-release
              wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
              echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
              sudo apt-get update
              sudo apt-get install trivy
              EOF

  tags = {
    Name = var.instance_name
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}