resource "tfe_project" "providers" {
  organization = "scaleout"
  name         = "providers"
}

resource "tfe_workspace" "providers" {
  for_each = toset([
    "azure-subscription-fast-dev",
    "aws-account-root",
    "cloudflare-dns",
    "gcp-project-fast-dev",
    "gcp-project-platform-dev",
    "istio-dev-ca"
  ])
  name                = "${tfe_project.providers.name}-${replace(each.value, "/", "-")}"
  organization        = "scaleout"
  project_id          = tfe_project.providers.id
  working_directory   = "infrastructure/providers/${each.value}"
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

//TODO configure variable sets

// Allow running locally for speed of initial creation/debugging.
resource "tfe_workspace_settings" "providers" {
  for_each       = tfe_workspace.providers
  workspace_id   = each.value.id
  execution_mode = "local"
}
