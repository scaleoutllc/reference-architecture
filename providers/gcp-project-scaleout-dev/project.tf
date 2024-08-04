resource "google_project" "main" {
  project_id          = "scaleout-dev"
  name                = "scaleout-dev"
  billing_account     = "0107CC-5B0989-308B51"
  org_id              = "140123624504"
  auto_create_network = "false"
}

resource "google_project_service" "main" {
  for_each = toset([
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "sts.googleapis.com",
    "iamcredentials.googleapis.com",
    "dns.googleapis.com",
    "certificatemanager.googleapis.com",
    "networkconnectivity.googleapis.com"
  ])
  project            = google_project.main.name
  service            = each.key
  disable_on_destroy = true
}
