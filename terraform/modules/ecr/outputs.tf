# modules/ecr/outputs.tf
output "repository_urls" {
  description = "URLs of the ECR repositories"
  value       = [for repo in aws_ecr_repository.repo : repo.repository_url]
}