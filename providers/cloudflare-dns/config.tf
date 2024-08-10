terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.24.0"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      project = "providers"
      name    = "providers-cloudflare-dns"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

variable "cloudflare_api_token" {}

// provider to aws account with route53 zones
provider "aws" {
  region = "us-east-1"
}
