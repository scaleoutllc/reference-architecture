locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  area     = "us"
  region   = "us-east1"
  project  = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.project}-${local.area}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp-us"
      name    = "fast-dev-gcp-us-cluster-namespaces-autoneg-system"
    }
  }
}

provider "google" {
  project = local.project
  region  = local.region
}

data "google_client_config" "caller" {}
data "google_container_cluster" "this_env" {
  name     = local.name
  location = local.region
  project  = local.project
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.this_env.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.this_env.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.caller.access_token
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.this_env.endpoint}"
    cluster_ca_certificate = base64decode(data.google_container_cluster.this_env.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.caller.access_token
  }
}
