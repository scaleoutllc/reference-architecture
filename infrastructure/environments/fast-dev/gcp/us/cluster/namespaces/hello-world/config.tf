locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  area     = "us"
  name     = "${local.team}-${local.env}-${local.provider}-${local.area}"
}

data "tfe_outputs" "cluster" {
  organization = "scaleout"
  workspace    = "fast-dev-gcp-us-cluster-gke"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp"
      name    = "fast-dev-gcp-us-cluster-namespaces-hello-world"
    }
  }
}

data "google_client_config" "this_env" {}

provider "kubernetes" {
  host                   = data.tfe_outputs.cluster.values.endpoint
  cluster_ca_certificate = data.tfe_outputs.cluster.values.ca-cert
  token                  = data.google_client_config.this_env.access_token
}

