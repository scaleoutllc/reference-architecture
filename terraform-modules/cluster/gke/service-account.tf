resource "google_service_account" "nodes" {
  account_id = var.name
}

resource "google_project_iam_member" "nodes-log-writer" {
  project = var.project
  role    = "roles/logging.logWriter"
  member  = google_service_account.nodes.member
}

resource "google_project_iam_member" "nodes-metric-writer" {
  project = var.project
  role    = "roles/monitoring.metricWriter"
  member  = google_service_account.nodes.member
}

resource "google_project_iam_member" "nodes-monitoring-viewer" {
  project = var.project
  role    = "roles/monitoring.viewer"
  member  = google_service_account.nodes.member
}

resource "google_project_iam_member" "nodes-resource-metadata-writer" {
  project = var.project
  role    = "roles/stackdriver.resourceMetadata.writer"
  member  = google_service_account.nodes.member
}

resource "google_project_iam_member" "nodes-gcr" {
  project = var.project
  role    = "roles/storage.objectViewer"
  member  = google_service_account.nodes.member
}

resource "google_project_iam_member" "nodes-artifact-registry" {
  project = var.project
  role    = "roles/artifactregistry.reader"
  member  = google_service_account.nodes.member
  //TODO: scope to specific registry?
}
