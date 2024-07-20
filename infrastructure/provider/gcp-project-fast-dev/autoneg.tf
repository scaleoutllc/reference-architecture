module "autoneg" {
  source             = "github.com/GoogleCloudPlatform/gke-autoneg-controller//terraform/gcp?ref=master"
  project_id         = google_project.main.name
  service_account_id = "autoneg"
  workload_identity = {
    namespace       = "autoneg-system"
    service_account = "autoneg-controller-manager"
  }
}
