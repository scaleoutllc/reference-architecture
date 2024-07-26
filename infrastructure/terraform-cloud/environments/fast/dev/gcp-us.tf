resource "tfe_project" "fast-dev-gcp-us" {
  organization = "scaleout"
  name         = "fast-dev-gcp-us"
}

resource "tfe_workspace" "fast-dev-gcp-us" {
  for_each = toset([
    "network",
    "cluster",
    "nodes",
    "namespaces/autoneg-system",
    "namespaces/kube-system",
    "namespaces/istio-system",
    "namespaces/ingress",
  ])
  name                = "${tfe_project.fast-dev-gcp-us.name}-${replace(each.value, "/", "-")}"
  organization        = "scaleout"
  project_id          = tfe_project.fast-dev-gcp-us.id
  working_directory   = "infrastructure/environments/fast/dev/gcp/us/${each.value}"
  global_remote_state = true
  vcs_repo {
    identifier     = "scaleoutllc/reference-architecture"
    oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
    branch         = "main"
  }
  lifecycle {
    prevent_destroy = false
  }
}

// Allow running locally for speed of initial creation/debugging.
resource "tfe_workspace_settings" "fast-dev-gcp-us" {
  for_each       = tfe_workspace.fast-dev-gcp-us
  workspace_id   = each.value.id
  execution_mode = "local"
}