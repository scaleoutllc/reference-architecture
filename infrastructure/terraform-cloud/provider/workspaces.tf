resource "tfe_project" "provider" {
  organization = "scaleout"
  name         = "provider"
}

resource "tfe_workspace" "provider" {
  for_each = toset([
    "aws-account-root",
    "gcp-project-fast-dev",
  ])
  name                = "${tfe_project.provider.name}-${replace(each.value, "/", "-")}"
  organization        = "scaleout"
  project_id          = tfe_project.provider.id
  working_directory   = "infrastructure/provider/${each.value}"
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
