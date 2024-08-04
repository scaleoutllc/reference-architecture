output "envs" {
  value = chomp(<<EOF
aws-us
aws-au
gcp-us
gcp-au
EOF
  )
}

output "ips" {
  value = chomp(<<EOF
${nonsensitive(data.tfe_outputs.aws-us.values.debug-ip)}
${nonsensitive(data.tfe_outputs.aws-au.values.debug-ip)}
${nonsensitive(data.tfe_outputs.gcp-us.values.debug-ip)}
${nonsensitive(data.tfe_outputs.gcp-au.values.debug-ip)}
EOF
  )
}

output "ssh" {
  value = chomp(<<EOF
ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -A -J ${nonsensitive(data.tfe_outputs.aws-us-shared.values.bastion-ssh)} ${nonsensitive(data.tfe_outputs.aws-us.values.debug-ssh)}
ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -A -J ${nonsensitive(data.tfe_outputs.aws-au-shared.values.bastion-ssh)} ${nonsensitive(data.tfe_outputs.aws-au.values.debug-ssh)}
ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -A ${nonsensitive(data.tfe_outputs.gcp-us.values.debug-ssh)}
ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -A ${nonsensitive(data.tfe_outputs.gcp-au.values.debug-ssh)}
EOF
  )
}

data "tfe_outputs" "aws-us-shared" {
  organization = "scaleout"
  workspace    = "shared-dev-aws-us-east-1-network"
}

data "tfe_outputs" "aws-au-shared" {
  organization = "scaleout"
  workspace    = "shared-dev-aws-ap-southeast-2-network"
}

data "tfe_outputs" "aws-us" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-us-east-1-network"
}

data "tfe_outputs" "aws-au" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-ap-southeast-2-network"
}

data "tfe_outputs" "gcp-us" {
  organization = "scaleout"
  workspace    = "fast-dev-gcp-us-east1-network"
}

data "tfe_outputs" "gcp-au" {
  organization = "scaleout"
  workspace    = "fast-dev-gcp-australia-southeast1-network"
}
