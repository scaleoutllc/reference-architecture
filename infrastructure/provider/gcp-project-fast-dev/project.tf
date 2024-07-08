resource "google_project" "fast-dev-gcp" {
  project_id      = "fast-dev-gcp"
  name            = "fast-dev-gcp"
  billing_account = "0107CC-5B0989-308B51"
  org_id          = "140123624504"
}

resource "google_project_service" "fast-dev-gcp" {
  for_each = toset([
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "sts.googleapis.com",
    "iamcredentials.googleapis.com",
    "dns.googleapis.com",
    "certificatemanager.googleapis.com",
  ])
  project            = google_project.fast-dev-gcp.name
  service            = each.key
  disable_on_destroy = true
}
