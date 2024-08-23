locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  region   = "australia-southeast1"
  locale   = "au"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
  project  = "scaleout-dev"
  domain   = "fast.dev.wescaleout.cloud"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp"
      name    = "fast-dev-gcp-australia-southeast1-workload-cluster-k8s-core-services"
    }
  }
}

provider "google" {
  project = local.project
  region  = local.region
}

// provider to aws account with route53 zone for this environment
provider "aws" {
  region = "us-east-1"
}

data "tfe_outputs" "ca" {
  organization = "scaleout"
  workspace    = "providers-istio-ca-dev"
}

data "google_client_config" "caller" {}
data "google_container_cluster" "this" {
  name     = local.name
  location = local.region
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.this.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.caller.access_token
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.this.endpoint}"
    cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.caller.access_token
  }
}
