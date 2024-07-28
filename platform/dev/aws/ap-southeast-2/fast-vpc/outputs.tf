output "layout" {
  value = local.network
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
