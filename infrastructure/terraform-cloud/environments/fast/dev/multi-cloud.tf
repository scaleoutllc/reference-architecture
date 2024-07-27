resource "tfe_project" "fast-dev-multi-cloud" {
  organization = "scaleout"
  name         = "fast-dev-multi-cloud"
}

resource "tfe_workspace" "fast-dev-multi-cloud" {
  name                = tfe_project.fast-dev-multi-cloud.name
  organization        = "scaleout"
  project_id          = tfe_project.fast-dev-multi-cloud.id
  working_directory   = "infrastructure/environments/fast/dev/multi-cloud"
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
resource "tfe_workspace_settings" "fast-dev-multi-cloud" {
  workspace_id   = tfe_workspace.fast-dev-multi-cloud.id
  execution_mode = "local"
}
