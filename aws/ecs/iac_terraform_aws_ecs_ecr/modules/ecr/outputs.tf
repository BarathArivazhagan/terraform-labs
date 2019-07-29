output "ecr_id" {
  value = aws_ecr_repository.repository.id
}

output "ecr_name" {
  value = aws_ecr_repository.repository.name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.repository.repository_url
}