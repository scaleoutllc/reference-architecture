resource "tfe_workspace" "platform-dns" {
  name                = "${tfe_project.platform.name}-dns"
  organization        = "scaleout"
  project_id          = tfe_project.platform.id
  working_directory   = "infrastructure/routing/dns"
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
