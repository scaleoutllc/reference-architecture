data "terraform_remote_state" "routing" {
  backend = "remote"

  config = {
    organization = "scaleout"
    workspaces = {
      name = "scaleout-platform-routing"
    }
  }
}

data "terraform_remote_state" "network" {
  backend = "remote"

  config = {
    organization = "scaleout"
    workspaces = {
      name = "aws-team-dev-au-network"
    }
  }
}

locals {
  routing = data.terraform_remote_state.routing.outputs
  network = data.terraform_remote_state.network.outputs
}
