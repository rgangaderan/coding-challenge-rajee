output "secret_string" {
  value       = aws_secretsmanager_secret_version.secret_key_private.secret_string
  sensitive   = true
  description = "Private ssh key output."
}

output "secret_arn" {
  value       = aws_secretsmanager_secret.secret_manager_name[0].arn
  description = "Secret Manager arn."
}
