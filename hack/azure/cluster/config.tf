locals {
  team            = "fast"
  env             = "dev"
  provider        = "azure"
  region          = "eastus"
  locale          = "us"
  area            = "${local.team}-${local.env}-${local.provider}"
  name            = "${local.area}-${local.locale}"
  subscription_id = "a659386b-33ac-4e4b-85fb-157e024ba574"
  # creatd in provider/azure-subscription-fast-dev
  admin_group_id = "a695acfd-ba95-49f9-b24e-ff5ad30f53f9"
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "fast-dev-azure-us-network"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-azure-us"
      name    = "fast-dev-azure-us-cluster"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = local.subscription_id
}

resource "azurerm_resource_group" "this" {
  name     = "${local.name}-aks"
  location = local.region
}
