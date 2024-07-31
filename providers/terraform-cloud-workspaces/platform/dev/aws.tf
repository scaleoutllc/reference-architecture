resource "tfe_project" "platform-dev-aws" {
  organization = "scaleout"
  name         = "platform-dev-aws"
}

locals {
  aws-root = "../../../../platform/dev/aws/"
}
resource "tfe_workspace" "platform-dev-aws" {
  for_each = toset(flatten([
    for file, _ in fileset(path.module, "${local.aws-root}**") :
    replace(dirname(file), local.aws-root, "") if strcontains(file, "config.tf")
  ]))
  name                = "${tfe_project.platform-dev-aws.name}-${replace(each.value, "/", "-")}"
  organization        = "scaleout"
  project_id          = tfe_project.platform-dev-aws.id
  working_directory   = "platform/dev/aws/${each.value}"
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
resource "tfe_workspace_settings" "platform-dev-aws" {
  for_each       = tfe_workspace.platform-dev-aws
  workspace_id   = each.value.id
  execution_mode = "local"
}
