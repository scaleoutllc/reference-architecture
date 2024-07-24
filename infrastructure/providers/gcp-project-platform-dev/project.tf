resource "google_project" "main" {
  project_id      = "platform-dev-gcp"
  name            = "platform-dev-gcp"
  billing_account = "0107CC-5B0989-308B51"
  org_id          = "140123624504"
}

resource "google_project_service" "main" {
  for_each = toset([
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
  ])
  project            = google_project.main.name
  service            = each.key
  disable_on_destroy = true
}
