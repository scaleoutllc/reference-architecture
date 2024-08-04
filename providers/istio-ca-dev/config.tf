terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "providers"
      name    = "providers-istio-ca-dev"
    }
  }
}
