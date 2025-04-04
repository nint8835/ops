locals {
  cluster_nodes = {
    k8s-control-plane-1 = {
      ip   = "10.8.1.1"
      role = "controlplane"
      zone = "aphrodite"
    }
    k8s-control-plane-2 = {
      ip   = "10.8.1.2"
      role = "controlplane"
      zone = "apollo"
    }
    k8s-control-plane-3 = {
      ip   = "10.8.1.3"
      role = "controlplane"
      zone = "zeus"
    }

    k8s-worker-1 = {
      ip   = "10.8.2.1"
      role = "worker"
      zone = "aphrodite"
    }
    k8s-worker-2 = {
      ip   = "10.8.2.2"
      role = "worker"
      zone = "apollo"
    }
    k8s-worker-3 = {
      ip   = "10.8.2.3"
      role = "worker"
      zone = "zeus"
    }
    k8s-worker-4 = {
      ip   = "10.8.2.4"
      role = "worker"
      zone = "helios"
    }
    k8s-worker-5 = {
      ip   = "10.8.2.5"
      role = "worker"
      zone = "eos"
    }
  }

  talos_version      = "1.9.5"
  kubernetes_version = "1.32.0"

  control_plane_nodes = { for k, v in local.cluster_nodes : k => v if v.role == "controlplane" }
  worker_nodes        = { for k, v in local.cluster_nodes : k => v if v.role == "worker" }
}

resource "talos_machine_secrets" "secrets" {}

module "control_plane_node" {
  source   = "./modules/node"
  for_each = local.control_plane_nodes

  name                 = each.key
  ip                   = each.value.ip
  region               = try(each.value.region, "hera")
  zone                 = each.value.zone
  role                 = "controlplane"
  cluster_name         = var.cluster_name
  cluster_endpoint     = "https://cluster.ops.bootleg.technology:6443"
  machine_secrets      = talos_machine_secrets.secrets.machine_secrets
  client_configuration = talos_machine_secrets.secrets.client_configuration

  talos_version      = local.talos_version
  kubernetes_version = local.kubernetes_version
}

module "worker_node" {
  source   = "./modules/node"
  for_each = local.worker_nodes

  name                 = each.key
  ip                   = each.value.ip
  region               = try(each.value.region, "hera")
  zone                 = each.value.zone
  role                 = "worker"
  cluster_name         = var.cluster_name
  cluster_endpoint     = "https://cluster.ops.bootleg.technology:6443"
  machine_secrets      = talos_machine_secrets.secrets.machine_secrets
  client_configuration = talos_machine_secrets.secrets.client_configuration

  talos_version      = local.talos_version
  kubernetes_version = local.kubernetes_version
}

resource "talos_machine_bootstrap" "cluster" {
  depends_on = [module.control_plane_node]

  node                 = local.control_plane_nodes.k8s-control-plane-1.ip
  client_configuration = talos_machine_secrets.secrets.client_configuration
}

data "talos_client_configuration" "config" {
  depends_on = [module.control_plane_node]

  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.secrets.client_configuration
  endpoints            = [for k, v in local.control_plane_nodes : v.ip]
}

resource "cloudflare_dns_record" "cluster" {
  for_each = local.control_plane_nodes

  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "cluster.ops.bootleg.technology"
  content = each.value.ip
  type    = "A"
  ttl     = 1
}

resource "talos_cluster_kubeconfig" "config" {
  depends_on = [module.control_plane_node]

  client_configuration = talos_machine_secrets.secrets.client_configuration
  node                 = local.control_plane_nodes.k8s-control-plane-1.ip
}
