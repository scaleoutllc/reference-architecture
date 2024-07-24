output "module" {
  value = module.network
}

output "subnet_cidrs" {
  value = local.network.subnets
}
