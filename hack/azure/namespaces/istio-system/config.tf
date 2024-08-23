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

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-azure-us"
      name    = "fast-dev-azure-us-namespaces-istio-system"
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

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.this.kube_admin_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_admin_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_admin_config.0.cluster_ca_certificate)
  }
}
