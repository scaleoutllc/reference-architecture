locals {
  provider    = "oci"
  team        = "fast"
  env         = "dev"
  area        = "us"
  name        = "${local.team}-${local.env}-${local.provider}-${local.area}"
  tags        = {}
  k8s_version = "1.28.2"
  network     = data.tfe_outputs.network.values
  kubeconfig  = yamldecode(data.oci_containerengine_cluster_kube_config.kubeconfig.content).clusters[0].cluster
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "fast-dev-oci-us-network"
}

data "oci_identity_availability_domains" "all" {
  compartment_id = var.compartment_id
}

data "oci_containerengine_cluster_kube_config" "kubeconfig" {
  cluster_id = oci_containerengine_cluster.main.id
}

variable "region" {}
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key" {}
variable "compartment_id" {}

provider "oci" {
  region       = var.region
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
}

terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "5.38.0"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-oci-us"
      name    = "fast-dev-oci-us-cluster-oke"
    }
  }
}
