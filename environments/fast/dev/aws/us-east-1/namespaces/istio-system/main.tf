module "istio-system" {
  source          = "../../../../../../../terraform-modules/aws-cluster/namespaces/istio-system"
  name            = local.name
  team            = local.team
  env             = local.env
  area            = local.area
  node_label_root = "node.wescaleout.cloud"
  ca_cert         = data.tfe_outputs.ca.values.cert
  ca_private_key  = data.tfe_outputs.ca.values.private_key
}
