output "vpc" {
  value = merge(module.vpc, {
    layout = local.network
  })
}

output "region" {
  value = local.region
}

output "account_id" {
  value = data.aws_caller_identity.this.account_id
}
