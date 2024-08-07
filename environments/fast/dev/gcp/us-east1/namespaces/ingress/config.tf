locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  region   = "us-east1"
  locale   = "us"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.region}"
  domain   = "fast.dev.wescaleout.cloud"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp"
      name    = "fast-dev-gcp-us-east1-namespaces-ingress"
    }
  }
}

// provider to aws account with route53 zone for this environment
provider "aws" {
  region = "us-east-1"
}

provider "google" {
  project = "scaleout-dev"
  region  = local.region
}

data "google_client_config" "caller" {}
data "google_container_cluster" "this" {
  name     = local.name
  location = local.region
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.this.endpoint}"
    cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.caller.access_token
  }
}


data "aws_route53_zone" "main" {
  name = local.domain
}
