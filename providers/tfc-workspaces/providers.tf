module "providers" {
  source             = "../../terraform-modules/tfc-project"
  basedir            = "providers"
  project            = "providers"
  workspace_prefix   = "providers"
  organization       = "scaleout"
  vcs_identifier     = "scaleoutllc/reference-architecture"
  vcs_oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
}
