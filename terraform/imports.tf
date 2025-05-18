import {
  to = proxmox_virtual_environment_pool.kubernetes
  id = "Kubernetes"
}

import {
  to = proxmox_virtual_environment_vm.k8s_worker_node["k8s-worker-1"]
  id = "aphrodite/100"
}

import {
  to = proxmox_virtual_environment_vm.k8s_worker_node["k8s-worker-2"]
  id = "apollo/101"
}

import {
  to = proxmox_virtual_environment_vm.k8s_worker_node["k8s-worker-3"]
  id = "zeus/102"
}

import {
  to = proxmox_virtual_environment_vm.k8s_worker_node["k8s-worker-4"]
  id = "helios/109"
}

import {
  to = proxmox_virtual_environment_vm.k8s_worker_node["k8s-worker-5"]
  id = "eos/110"
}

import {
  to = proxmox_virtual_environment_vm.k8s_control_plane_node["k8s-control-plane-1"]
  id = "aphrodite/103"
}

import {
  to = proxmox_virtual_environment_vm.k8s_control_plane_node["k8s-control-plane-2"]
  id = "apollo/104"
}

import {
  to = proxmox_virtual_environment_vm.k8s_control_plane_node["k8s-control-plane-3"]
  id = "zeus/105"
}
