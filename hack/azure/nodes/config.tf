locals {
  team            = "fast"
  env             = "dev"
  provider        = "azure"
  region          = "eastus"
  locale          = "us"
  area            = "${local.team}-${local.env}-${local.provider}"
  name            = "${local.area}-${local.locale}"
  subscription_id = "a659386b-33ac-4e4b-85fb-157e024ba574"
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
      name    = "fast-dev-azure-us-nodes"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = local.subscription_id
}

data "azurerm_kubernetes_cluster" "this" {
  name                = local.name
  resource_group_name = "${local.name}-aks"
}
