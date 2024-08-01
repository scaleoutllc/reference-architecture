data "tfe_outputs" "us-east-1-transit-vpc" {
  organization = "scaleout"
  workspace    = "platform-dev-aws-us-east-1-transit-vpc"
}

data "tfe_outputs" "ap-southeast-2-transit-vpc" {
  organization = "scaleout"
  workspace    = "platform-dev-aws-ap-southeast-2-transit-vpc"
}

data "tfe_outputs" "us-east-1-fast-vpc" {
  organization = "scaleout"
  workspace    = "platform-dev-aws-us-east-1-fast-vpc"
}

data "tfe_outputs" "ap-southeast-2-fast-vpc" {
  organization = "scaleout"
  workspace    = "platform-dev-aws-ap-southeast-2-fast-vpc"
}

output "envs" {
  value = chomp(<<EOF
aws-au
aws-us
EOF
  )
}

output "ips" {
  value = chomp(<<EOF
${nonsensitive(data.tfe_outputs.us-east-1-fast-vpc.values.debug-ip)}
${nonsensitive(data.tfe_outputs.ap-southeast-2-fast-vpc.values.debug-ip)}
EOF
  )
}

output "ssh" {
  value = chomp(<<EOF
${nonsensitive(data.tfe_outputs.us-east-1-transit-vpc.values.bastion-ssh)} ${nonsensitive(data.tfe_outputs.us-east-1-fast-vpc.values.debug-ssh)}
${nonsensitive(data.tfe_outputs.ap-southeast-2-transit-vpc.values.bastion-ssh)} ${nonsensitive(data.tfe_outputs.ap-southeast-2-fast-vpc.values.debug-ssh)}
EOF
  )
}

how can i read these two lines into a bash array?
ubuntu@3.237.88.145 ubuntu@10.10.2.165
ubuntu@13.210.241.239 ubuntu@10.20.0.96