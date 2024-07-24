terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "provider"
      name    = "provider-azure-subscription-fast-dev"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {
  tenant_id = "1f8e11f4-08fe-495c-9976-c2761413d93c"
}
