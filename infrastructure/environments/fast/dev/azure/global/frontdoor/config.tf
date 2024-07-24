locals {
  team            = "fast"
  env             = "dev"
  provider        = "azure"
  region          = "global"
  locale          = "global"
  area            = "${local.team}-${local.env}-${local.provider}"
  name            = "${local.area}-${local.locale}"
  subscription_id = "a659386b-33ac-4e4b-85fb-157e024ba574"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-global"
      name    = "fast-dev-global-azure-frontdoor"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = local.subscription_id
}

resource "azurerm_resource_group" "this" {
  name     = "${local.name}-frontdoor"
  location = local.region
}
