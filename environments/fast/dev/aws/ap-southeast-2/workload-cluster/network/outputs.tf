output "config" {
  value = local.network
}

output "name" {
  value = local.name
}

output "vpc" {
  value = module.vpc
}

output "region" {
  value = local.region
}

output "account_id" {
  value = data.aws_caller_identity.this.account_id
}
