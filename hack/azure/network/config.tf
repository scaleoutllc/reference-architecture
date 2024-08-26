locals {
  team     = "fast"
  env      = "dev"
  provider = "azure"
  region   = "eastus"
  locale   = "us"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
  // 10.50.0.0/20
  // https://www.davidc.net/sites/default/subnets/subnets.html?network=10.50.0.0&mask=20&division=7.51
  network = {
    cidr = "10.50.0.0/20"
    subnets = {
      pods      = "10.50.0.0/21"
      data      = "10.50.8.0/22"
      services  = "10.50.12.0/23"
      apiserver = "10.50.14.0/23"
    }
  }
  subscription_id = "a659386b-33ac-4e4b-85fb-157e024ba574"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-azure-us"
      name    = "fast-dev-azure-us-network"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = local.subscription_id
}

resource "azurerm_resource_group" "this" {
  name     = "${local.name}-network"
  location = local.region
}
