module "user" {
  source = "../../../../../../../terraform-modules/host-user"
}

resource "helm_release" "routing" {
  name      = "routing"
  namespace = "ingress"
  chart     = "${path.module}/chart"
  set {
    name  = "domain"
    value = "${module.user.name}-${local.locale}-mgmt.${local.domain}"
  }
}
