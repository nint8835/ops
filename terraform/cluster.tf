locals {
  cluster_nodes = {
    k8s-control-plane-1 = {
      ip   = "10.8.1.1"
      role = "controlplane"
      host = "aphrodite"
    }
    k8s-control-plane-2 = {
      ip   = "10.8.1.2"
      role = "controlplane"
      host = "apollo"
    }
    k8s-control-plane-3 = {
      ip   = "10.8.1.3"
      role = "controlplane"
      host = "zeus"
    }

    k8s-worker-1 = {
      ip   = "10.8.2.1"
      role = "worker"
      host = "aphrodite"
    }
    k8s-worker-2 = {
      ip   = "10.8.2.2"
      role = "worker"
      host = "apollo"
    }
    k8s-worker-3 = {
      ip   = "10.8.2.3"
      role = "worker"
      host = "zeus"
    }
    k8s-worker-4 = {
      ip   = "10.8.2.4"
      role = "worker"
      host = "helios"
    }
    k8s-worker-5 = {
      ip   = "10.8.2.5"
      role = "worker"
      host = "eos"
    }
  }

  talos_version      = "1.14.0"
  kubernetes_version = "1.37.0"

  control_plane_nodes = { for k, v in local.cluster_nodes : k => v if v.role == "controlplane" }
}

check "cluster_inventory" {
  assert {
    condition     = length(local.control_plane_nodes) > 0
    error_message = "The cluster inventory must contain at least one control-plane node."
  }

  assert {
    condition     = length(distinct([for node in values(local.cluster_nodes) : node.ip])) == length(local.cluster_nodes)
    error_message = "Every cluster node must have a unique IP address."
  }

  assert {
    condition     = alltrue([for node in values(local.cluster_nodes) : contains(keys(local.proxmox_hosts), node.host)])
    error_message = "Every cluster node must reference a host defined in local.proxmox_hosts."
  }
}

resource "proxmox_virtual_environment_pool" "kubernetes" {
  pool_id = "Kubernetes"
}

resource "talos_machine_secrets" "secrets" {}

module "node" {
  source   = "./modules/node"
  for_each = local.cluster_nodes

  name                 = each.key
  ip                   = each.value.ip
  region               = try(each.value.region, "hera")
  zone                 = each.value.host
  host_name            = each.value.host
  proxmox_pool_id      = proxmox_virtual_environment_pool.kubernetes.pool_id
  role                 = each.value.role
  cluster_name         = var.cluster_name
  cluster_endpoint     = "https://cluster.ops.bootleg.technology:6443"
  machine_secrets      = talos_machine_secrets.secrets.machine_secrets
  client_configuration = talos_machine_secrets.secrets.client_configuration

  talos_version      = local.talos_version
  kubernetes_version = local.kubernetes_version
}

resource "talos_machine_bootstrap" "cluster" {
  depends_on = [module.node]

  node                 = local.control_plane_nodes.k8s-control-plane-1.ip
  client_configuration = talos_machine_secrets.secrets.client_configuration
}

data "talos_client_configuration" "config" {
  depends_on = [module.node]

  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.secrets.client_configuration
  endpoints            = [for k, v in local.control_plane_nodes : v.ip]
}

resource "talos_cluster_kubeconfig" "config" {
  client_configuration = talos_machine_secrets.secrets.client_configuration
  node                 = local.control_plane_nodes.k8s-control-plane-1.ip

  depends_on = [talos_machine_bootstrap.cluster]
}
