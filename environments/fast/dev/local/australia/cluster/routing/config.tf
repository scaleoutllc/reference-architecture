locals {
  team     = "fast"
  env      = "dev"
  provider = "local"
  region   = "australia"
  locale   = "au"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
  domain   = "fast.dev.wescaleout.cloud"
}

data "terraform_remote_state" "cluster" {
  backend = "local"

  config = {
    path = "${path.module}/../k8s/terraform.tfstate"
  }
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.cluster.outputs.endpoint
    cluster_ca_certificate = data.terraform_remote_state.cluster.outputs.cluster_ca_certificate
    client_key             = data.terraform_remote_state.cluster.outputs.client_key
    client_certificate     = data.terraform_remote_state.cluster.outputs.client_certificate
  }
}
