locals {
  provider       = "oci"
  team           = "team"
  env            = "dev"
  region         = "us"
  workspace      = "routing"
  envName        = "${local.provider}-${local.team}-${local.env}-${local.region}"
  name           = "${local.envName}-${local.workspace}"
  tags           = {}
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaaqmdyo455h7pgzmgvsn5ue4dg73oxhp47udjc66c3vlg5h7wyzvsa"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=5.45"
    }
    oci = {
      source  = "oracle/oci"
      version = "5.38.0"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      project = "oci-team-dev-us"
      name    = "oci-team-dev-us-routing"
    }
  }
}

provider "oci" {
  region              = "us-chicago-1"
  config_file_profile = "scaleout"
}

provider "aws" {
  region  = "us-east-1"
  profile = "us"
}