resource "tfe_project" "platform-dev-gcp" {
  organization = "scaleout"
  name         = "platform-dev-gcp"
}

locals {
  gcp-root = "../../../../platform/dev/gcp/"
}
resource "tfe_workspace" "platform-dev-gcp" {
  for_each = toset(flatten([
    for file, _ in fileset(path.module, "${local.gcp-root}**") :
    replace(dirname(file), local.gcp-root, "") if strcontains(file, "config.tf")
  ]))
  name                = "${tfe_project.platform-dev-gcp.name}-${replace(each.value, "/", "-")}"
  organization        = "scaleout"
  project_id          = tfe_project.platform-dev-gcp.id
  working_directory   = "platform/dev/gcp/${each.value}"
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
resource "tfe_workspace_settings" "platform-dev-gcp" {
  for_each       = tfe_workspace.platform-dev-gcp
  workspace_id   = each.value.id
  execution_mode = "local"
}
