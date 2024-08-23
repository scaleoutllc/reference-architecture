locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  region   = "us-east1"
  locale   = "us"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
  project  = "scaleout-dev"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp"
      name    = "fast-dev-gcp-us-east1-workload-cluster-k8s-routing"
    }
  }
  required_providers {
    kustomization = {
      source = "kbst/kustomization"
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


data "google_client_config" "caller" {}
data "google_container_cluster" "this" {
  name     = local.name
  location = local.region
}

provider "kustomization" {
  kubeconfig_raw = yamlencode({
    apiVersion = "v1"
    clusters = [{
      name = local.name
      cluster = {
        certificate-authority-data = data.google_container_cluster.this.master_auth[0].cluster_ca_certificate
        server                     = "https://${data.google_container_cluster.this.endpoint}"
      }
    }]
    users = [{
      name = local.name
      user = {
        token = data.google_client_config.caller.access_token
      }
    }]
    contexts = [{
      name = local.name
      context = {
        cluster = local.name
        user    = local.name
      }
    }]
  })
  context = local.name
}
