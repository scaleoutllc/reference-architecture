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
  workspace    = "fast-dev-aws-us-east-1-workload-cluster-network"
}

data "tfe_outputs" "aws-au" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-ap-southeast-2-workload-cluster-network"
}

data "tfe_outputs" "gcp-us" {
  organization = "scaleout"
  workspace    = "fast-dev-gcp-us-east1-workload-cluster-network"
}

data "tfe_outputs" "gcp-au" {
  organization = "scaleout"
  workspace    = "fast-dev-gcp-australia-southeast1-workload-cluster-network"
}
