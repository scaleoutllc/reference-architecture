output "peering-attachment-id" {
  value = {
    us-east-1-to-ap-southeast-2 = module.peering-us-east-1-to-ap-southeast-2.attachment_id
  }
}

output "transit-gateway" {
  sensitive = true
  value = {
    us-east-1      = module.transit-gateway-us-east-1
    ap-southeast-2 = module.transit-gateway-ap-southeast-2
  }
}
