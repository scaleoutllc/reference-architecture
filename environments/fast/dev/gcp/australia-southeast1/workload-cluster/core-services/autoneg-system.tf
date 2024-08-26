module "autoneg-system" {
  source  = "../../../../../../../terraform-modules/cluster/services/gcp-autoneg-system"
  project = local.project
}
