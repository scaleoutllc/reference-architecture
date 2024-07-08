locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  area     = "au"
  name     = "${local.team}-${local.env}-${local.provider}-${local.area}"
}

data "tfe_outputs" "cluster" {
  organization = "scaleout"
  workspace    = "fast-dev-gcp-au-cluster-gke"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp-au"
      name    = "fast-dev-gcp-au-cluster-namespaces-kube-system"
    }
  }
}

provider "google" {
  project = "fast-dev-gcp"
  region  = "australia-southeast1"
}

provider "aws" {
  region = "us-east-1"
}

data "google_client_config" "this_env" {}

provider "kubernetes" {
  host                   = data.tfe_outputs.cluster.values.endpoint
  cluster_ca_certificate = data.tfe_outputs.cluster.values.ca-cert
  token                  = data.google_client_config.this_env.access_token
}

provider "helm" {
  kubernetes {
    host                   = data.tfe_outputs.cluster.values.endpoint
    cluster_ca_certificate = data.tfe_outputs.cluster.values.ca-cert
    token                  = data.google_client_config.this_env.access_token
  }
}
