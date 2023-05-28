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
