resource "tfe_project" "main" {
  organization = var.organization
  name         = var.project
}

locals {
  toRoot = "${path.module}/../../"
}
resource "tfe_workspace" "main" {
  for_each = toset(flatten([
    for file, _ in fileset("${local.toRoot}${var.basedir}", "**") :
    replace(dirname(file), local.toRoot, "") if strcontains(file, "config.tf")
  ]))
  name                = "${var.workspace_prefix}-${replace(each.value, "/", "-")}"
  organization        = var.organization
  project_id          = tfe_project.main.id
  working_directory   = "${var.basedir}/${each.value}"
  global_remote_state = true
  vcs_repo {
    identifier     = var.vcs_identifier
    oauth_token_id = var.vcs_oauth_token_id
    branch         = "main"
  }
  lifecycle {
    prevent_destroy = false
  }
}

// Allow running locally for speed of initial creation/debugging.
resource "tfe_workspace_settings" "main" {
  for_each       = tfe_workspace.main
  workspace_id   = each.value.id
  execution_mode = "local"
}
