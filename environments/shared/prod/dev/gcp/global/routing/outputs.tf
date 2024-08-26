output "hub_id" {
  value = google_network_connectivity_hub.main.id
}

# output "envs" {
#   value = chomp(<<EOF
# gcp-us
# gcp-au
# EOF
#   )
# }

# output "ips" {
#   value = chomp(<<EOF
# ${nonsensitive(data.tfe_outputs.gcp-us.values.debug-ip)}
# ${nonsensitive(data.tfe_outputs.gcp-au.values.debug-ip)}
# EOF
#   )
# }

# output "ssh" {
#   value = chomp(<<EOF
# ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -A -J ${nonsensitive(data.tfe_outputs.gcp-us-shared.values.bastion-ssh)} ${nonsensitive(data.tfe_outputs.gcp-us.values.debug-ssh)}
# ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -A -J ${nonsensitive(data.tfe_outputs.gcp-au-shared.values.bastion-ssh)} ${nonsensitive(data.tfe_outputs.gcp-au.values.debug-ssh)}
# EOF
#   )
# }
