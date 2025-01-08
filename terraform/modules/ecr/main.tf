# modules/ecr/main.tf
resource "aws_ecr_repository" "repos" {
  count = length(var.repository_names)
  name  = var.repository_names[count.index]

  image_scanning_configuration {
    scan_on_push = true
  }
}