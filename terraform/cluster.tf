locals {
  control_plane_nodes = {
    k8s-control-plane-1 = "10.8.1.1"
  }
}

resource "talos_machine_secrets" "secrets" {}

module "control_plane_node" {
  source   = "./modules/node"
  for_each = local.control_plane_nodes

  name                 = each.key
  ip                   = each.value
  role                 = "controlplane"
  cluster_name         = var.cluster_name
  cluster_endpoint     = "https://${local.control_plane_nodes.k8s-control-plane-1}:6443"
  machine_secrets      = talos_machine_secrets.secrets.machine_secrets
  client_configuration = talos_machine_secrets.secrets.client_configuration
}

resource "talos_machine_bootstrap" "cluster" {
  depends_on = [module.control_plane_node]

  node                 = local.control_plane_nodes.k8s-control-plane-1
  client_configuration = talos_machine_secrets.secrets.client_configuration
}

data "talos_client_configuration" "config" {
  depends_on = [module.control_plane_node]

  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.secrets.client_configuration
  endpoints            = [for k, v in local.control_plane_nodes : v]
}

data "talos_cluster_kubeconfig" "config" {
  client_configuration = talos_machine_secrets.secrets.client_configuration
  node                 = local.control_plane_nodes.k8s-control-plane-1
  wait                 = true
}
