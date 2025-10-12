variable "ip" {
  description = "IP address of the cluster node."
  type        = string
}

variable "name" {
  description = "Name of the cluster node."
  type        = string
}

variable "role" {
  description = "Role of the cluster node. Must be one of worker or controlplane."
  type        = string
}

variable "cluster_name" {
  description = "Name of the Talos cluster to join."
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint of the Talos cluster to join."
  type        = string
}

variable "machine_secrets" {
  description = "Talos machine secrets to use to join."
  type        = any
}

variable "client_configuration" {
  description = "Talos client configuration to use to join."
  type        = any
}

variable "region" {
  description = "Value for the topology.kubernetes.io/region label."
  type        = string
}

variable "zone" {
  description = "Value for the topology.kubernetes.io/zone label."
  type        = string
}

variable "talos_version" {
  description = "Version of Talos to install."
  type        = string
}

variable "kubernetes_version" {
  description = "Version of Kubernetes to install."
  type        = string
}

variable "host_name" {
  description = "Name of the Proxmox host to run this node on."
  type        = string
}

variable "proxmox_pool_id" {
  description = "ID of the Proxmox pool to add this VM to."
  type        = string
}

variable "host_device_id" {
  description = "ID of the Netbox device representing the Proxmox host to run this node on."
  type        = number
}

variable "netbox_cluster_id" {
  description = "ID of the Netbox cluster that this node's VM will run in."
  type        = number
}

variable "netbox_site_id" {
  description = "ID of the Netbox site that this node's VM will be located in."
  type        = number
}
