resource "kind_cluster" "main" {
  name = var.name
  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"
      kubeadm_config_patches = [<<-EOF
kind: ClusterConfiguration
apiServer:
  extraArgs:
    enable-admission-plugins: "NamespaceLifecycle,LimitRanger,ServiceAccount,TaintNodesByCondition,Priority,DefaultTolerationSeconds,DefaultStorageClass,PersistentVolumeClaimResize,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota"
    service-node-port-range: "80-32767"
EOF
      ]
    }
    node {
      role = "worker"
      labels = {
        "${var.node_label_root}/system" = true
      }
    }
    node {
      role = "worker"
      labels = {
        "${var.node_label_root}/routing" = true
      }
    }
    node {
      role = "worker"
      labels = {
        "${var.node_label_root}/app" = true
      }
    }
  }
}

data "external" "ingress_node" {
  program = [
    "bash",
    "-c",
    <<EOF
kubectl get nodes \
  --context kind-${var.name} \
  -l ${var.node_label_root}/routing=true \
  -o jsonpath='{.items[0].status.addresses[0]}'
EOF
  ]
  depends_on = [
    kind_cluster.main
  ]
}

module "user" {
  source = "../../host-user"
}
