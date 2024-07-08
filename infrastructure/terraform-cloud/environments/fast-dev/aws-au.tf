resource "tfe_project" "fast-dev-aws-au" {
  organization = "scaleout"
  name         = "fast-dev-aws-au"
}

resource "tfe_project_variable_set" "fast-dev-aws-au" {
  project_id      = tfe_project.fast-dev-aws-au.id
  variable_set_id = data.tfe_variable_set.aws-account-root.id
}

resource "tfe_workspace" "fast-dev-aws-au" {
  for_each = toset([
    "network",
    "tls",
    "cluster/eks",
    "cluster/nodes",
    "cluster/namespaces/kube-system",
    "cluster/namespaces/istio-system",
    "cluster/namespaces/hello-world",
  ])
  name                = "${tfe_project.fast-dev-aws-au.name}-${replace(each.value, "/", "-")}"
  organization        = "scaleout"
  project_id          = tfe_project.fast-dev-aws-au.id
  working_directory   = "infrastructure/environments/fast-dev/aws/au/${each.value}"
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
resource "tfe_workspace_settings" "fast-dev-aws-au" {
  for_each       = tfe_workspace.fast-dev-aws-au
  workspace_id   = each.value.id
  execution_mode = "local"
}
