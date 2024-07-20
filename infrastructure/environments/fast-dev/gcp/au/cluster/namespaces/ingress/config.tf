locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  area     = "au"
  region   = "australia-southeast1"
  project  = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.project}-${local.area}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp-au"
      name    = "fast-dev-gcp-au-cluster-namespaces-ingress"
    }
  }
}

data "google_client_config" "caller" {}
data "google_container_cluster" "this_env" {
  name     = local.name
  location = local.region
  project  = local.project
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.this_env.endpoint}"
    cluster_ca_certificate = base64decode(data.google_container_cluster.this_env.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.caller.access_token
  }
}
