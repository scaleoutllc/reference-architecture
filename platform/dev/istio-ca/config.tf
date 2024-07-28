terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "providers"
      name    = "providers-istio-dev-ca"
    }
  }
}
