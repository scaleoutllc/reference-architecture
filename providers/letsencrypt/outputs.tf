output "email" {
  value = "info@wescaleout.com"
}

output "private_key" {
  sensitive = true
  value     = tls_private_key.main.private_key_pem
}

output "role_arn" {
  value = aws_iam_role.main.arn
}

// only for use with local clusters, role assumption used in cloud.
output "aws_access_key_id" {
  value = aws_iam_access_key.main.id
}

output "aws_secret_access_key" {
  value     = aws_iam_access_key.main.secret
  sensitive = true
}
