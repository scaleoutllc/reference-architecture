resource "tfe_project" "fast-dev-gcp-au" {
  organization = "scaleout"
  name         = "fast-dev-gcp-au"
}

resource "tfe_workspace" "fast-dev-gcp-au" {
  for_each = toset([
    "network",
    "cluster/gke",
    "cluster/nodes",
    "cluster/namespaces/autoneg-system",
    "cluster/namespaces/kube-system",
    "cluster/namespaces/istio-system",
    "cluster/namespaces/hello-world",
  ])
  name                = "${tfe_project.fast-dev-gcp-au.name}-${replace(each.value, "/", "-")}"
  organization        = "scaleout"
  project_id          = tfe_project.fast-dev-gcp-au.id
  working_directory   = "infrastructure/environments/fast-dev/gcp/au/${each.value}"
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
resource "tfe_workspace_settings" "fast-dev-gcp-au" {
  for_each       = tfe_workspace.fast-dev-gcp-au
  workspace_id   = each.value.id
  execution_mode = "local"
}
