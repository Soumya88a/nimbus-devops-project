output "ecr_repository_url" {
  value = aws_ecr_repository.nimbus.repository_url
}

output "instance_id" {
  value = aws_instance.staging.id
}

output "staging_public_ip" {
  value = aws_instance.staging.public_ip
}

output "github_actions_role_arn" {
  value = aws_iam_role.github.arn
}

output "region" {
  value = var.aws_region
}
