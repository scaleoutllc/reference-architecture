terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "providers"
      name    = "aws-iam-accounts"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
