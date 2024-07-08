resource "tfe_project" "fast-dev-aws-routing" {
  organization = "scaleout"
  name         = "fast-dev-aws-routing"
}

resource "tfe_project_variable_set" "fast-dev-aws-routing" {
  project_id      = tfe_project.fast-dev-aws-routing.id
  variable_set_id = data.tfe_variable_set.aws-account-root.id
}

resource "tfe_workspace" "fast-dev-aws-routing" {
  name                = tfe_project.fast-dev-aws-routing.name
  organization        = "scaleout"
  project_id          = tfe_project.fast-dev-aws-routing.id
  working_directory   = "infrastructure/environments/fast-dev/aws/routing"
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
resource "tfe_workspace_settings" "fast-dev-aws-routing" {
  workspace_id   = tfe_workspace.fast-dev-aws-routing.id
  execution_mode = "local"
}
