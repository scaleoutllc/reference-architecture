resource "tfe_variable_set" "access" {
  name         = "gcp-project-fast-dev"
  organization = "scaleout"
}

resource "tfe_variable" "access" {
  for_each = {
    TFC_GCP_PROVIDER_AUTH             = true
    TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL = google_service_account.tfc.email
    TFC_GCP_PROJECT_NUMBER            = google_project.fast-dev-gcp.number
    TFC_GCP_WORKLOAD_POOL_ID          = google_iam_workload_identity_pool.tfc.id
    TFC_GCP_WORKLOAD_PROVIDER_ID      = google_iam_workload_identity_pool_provider.tfc.id
  }
  variable_set_id = tfe_variable_set.access.id
  key             = each.key
  value           = each.value
  category        = "env"
}
