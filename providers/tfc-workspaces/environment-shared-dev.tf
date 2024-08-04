module "shared-dev-aws" {
  source             = "../../terraform-modules/tfc-project"
  basedir            = "environments/shared/dev/aws"
  project            = "shared-dev-aws"
  workspace_prefix   = "shared-dev-aws"
  organization       = "scaleout"
  vcs_identifier     = "scaleoutllc/reference-architecture"
  vcs_oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
}

module "shared-dev-gcp" {
  source             = "../../terraform-modules/tfc-project"
  basedir            = "environments/shared/dev/gcp"
  project            = "shared-dev-gcp"
  workspace_prefix   = "shared-dev-gcp"
  organization       = "scaleout"
  vcs_identifier     = "scaleoutllc/reference-architecture"
  vcs_oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
}

module "shared-dev-multi-cloud" {
  source             = "../../terraform-modules/tfc-project"
  basedir            = "environments/shared/dev/multi-cloud"
  project            = "shared-dev-multi-cloud"
  workspace_prefix   = "shared-dev-multi-cloud"
  organization       = "scaleout"
  vcs_identifier     = "scaleoutllc/reference-architecture"
  vcs_oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
}
