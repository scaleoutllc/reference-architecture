module "fast-dev-aws" {
  source             = "../../terraform-modules/tfc-project"
  basedir            = "environments/fast/dev/aws"
  project            = "fast-dev-aws"
  workspace_prefix   = "fast-dev-aws"
  organization       = "scaleout"
  vcs_identifier     = "scaleoutllc/reference-architecture"
  vcs_oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
}

module "fast-dev-gcp" {
  source             = "../../terraform-modules/tfc-project"
  basedir            = "environments/fast/dev/gcp"
  project            = "fast-dev-gcp"
  workspace_prefix   = "fast-dev-gcp"
  organization       = "scaleout"
  vcs_identifier     = "scaleoutllc/reference-architecture"
  vcs_oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
}

module "fast-dev-multi-cloud" {
  source             = "../../terraform-modules/tfc-project"
  basedir            = "environments/fast/dev/multi-cloud"
  project            = "fast-dev-multi-cloud"
  workspace_prefix   = "fast-dev-multi-cloud"
  organization       = "scaleout"
  vcs_identifier     = "scaleoutllc/reference-architecture"
  vcs_oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
}

module "fast-dev-local" {
  source             = "../../terraform-modules/tfc-project"
  basedir            = "environments/fast/dev/local"
  project            = "fast-dev-local"
  workspace_prefix   = "fast-dev-local"
  organization       = "scaleout"
  vcs_identifier     = "scaleoutllc/reference-architecture"
  vcs_oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
}
