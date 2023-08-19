locals {
  control_plane_nodes = {
    k8s-control-plane-1 = "10.8.1.1",
    k8s-control-plane-2 = "10.8.1.2",
    k8s-control-plane-3 = "10.8.1.3",
  }
  worker_nodes = {
    k8s-worker-1 = "10.8.2.1",
    k8s-worker-2 = "10.8.2.2",
    k8s-worker-3 = "10.8.2.3",
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
  cluster_endpoint     = "https://cluster.ops.bootleg.technology:6443"
  machine_secrets      = talos_machine_secrets.secrets.machine_secrets
  client_configuration = talos_machine_secrets.secrets.client_configuration
}

module "worker_node" {
  source   = "./modules/node"
  for_each = local.worker_nodes

  name                 = each.key
  ip                   = each.value
  role                 = "worker"
  cluster_name         = var.cluster_name
  cluster_endpoint     = "https://cluster.ops.bootleg.technology:6443"
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

resource "cloudflare_record" "cluster" {
  for_each = local.control_plane_nodes

  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "cluster.ops"
  value   = each.value
  type    = "A"
}

data "talos_cluster_kubeconfig" "config" {
  depends_on = [module.control_plane_node]

  client_configuration = talos_machine_secrets.secrets.client_configuration
  node                 = local.control_plane_nodes.k8s-control-plane-1
  wait                 = true
}
