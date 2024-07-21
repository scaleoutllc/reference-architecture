resource "tfe_workspace" "fast-dev-global-gcp" {
  for_each = toset([
    "load-balancer"
  ])
  name                = "${tfe_project.fast-dev-global.name}-gcp-${each.key}"
  organization        = "scaleout"
  project_id          = tfe_project.fast-dev-global.id
  working_directory   = "infrastructure/environments/fast/dev/gcp/global/${each.key}"
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

resource "tfe_workspace_variable_set" "fast-dev-global-gcp" {
  for_each        = tfe_workspace.fast-dev-global-gcp
  workspace_id    = each.value.id
  variable_set_id = data.tfe_variable_set.gcp-project-fast-dev.id
}

// Allow running locally for speed of initial creation/debugging.
resource "tfe_workspace_settings" "fast-dev-global-gcp" {
  for_each       = tfe_workspace.fast-dev-global-gcp
  workspace_id   = each.value.id
  execution_mode = "local"
}
