# module "debug" {
#   source     = "../../../../../../shared/terraform/azure-debug-vm"
#   name       = "debug"
#   username   = "tkellen"
#   public_key = file("~/.ssh/id_rsa.pub")
#   subnet_id  = lookup(module.network.vnet_subnets_name_id, "pods")
#   location   = local.region
# }

# output "debug_vm_public_ip" {
#   value = module.debug.public_ip
# }
