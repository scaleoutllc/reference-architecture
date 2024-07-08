resource "tfe_project" "fast-dev-gcp-routing" {
  organization = "scaleout"
  name         = "fast-dev-gcp-routing"
}

resource "tfe_project_variable_set" "fast-dev-gcp-routing" {
  project_id      = tfe_project.fast-dev-gcp-routing.id
  variable_set_id = data.tfe_variable_set.gcp-project-fast-dev.id
}

resource "tfe_workspace" "fast-dev-gcp-routing" {
  name                = tfe_project.fast-dev-gcp-routing.name
  organization        = "scaleout"
  project_id          = tfe_project.fast-dev-gcp-routing.id
  working_directory   = "infrastructure/environments/fast-dev/gcp/routing"
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
resource "tfe_workspace_settings" "fast-dev-gcp-routing" {
  workspace_id   = tfe_workspace.fast-dev-gcp-routing.id
  execution_mode = "local"
}
