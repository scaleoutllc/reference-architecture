locals {
  team     = "plaform"
  env      = "dev"
  provider = "aws"
  region   = "global"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.region}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "platform-dev-aws"
      name    = "platform-dev-aws-routing"
    }
  }
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "ap-southeast-2"
  region = "ap-southeast-2"
}

data "tfe_outputs" "us-east-1-transit-vpc" {
  organization = "scaleout"
  workspace    = "platform-dev-aws-us-east-1-transit-vpc"
}

data "tfe_outputs" "ap-southeast-2-transit-vpc" {
  organization = "scaleout"
  workspace    = "platform-dev-aws-ap-southeast-2-transit-vpc"
}

data "tfe_outputs" "us-east-1-fast-vpc" {
  organization = "scaleout"
  workspace    = "platform-dev-aws-us-east-1-fast-vpc"
}

data "tfe_outputs" "ap-southeast-2-fast-vpc" {
  organization = "scaleout"
  workspace    = "platform-dev-aws-ap-southeast-2-fast-vpc"
}
