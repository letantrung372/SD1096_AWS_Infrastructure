# modules/ecr/main.tf
resource "aws_ecr_repository" "repo" {
  count = length(var.repositories)
  name  = "${var.environment}-${var.repositories[count.index]}"
  
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "policy" {
  count      = length(var.repositories)
  repository = aws_ecr_repository.repo[count.index].name
  
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 30 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 30
      }
      action = {
        type = "expire"
      }
    }]
  })
}

resource "aws_ecr_repository_policy" "public_access" {
  count      = length(var.repositories)
  repository = aws_ecr_repository.repo[count.index].name

  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Sid       = "AllowPublicRead",
        Effect    = "Allow",
        Principal = "*",
        Action    = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
      }
    ]
  })
}
