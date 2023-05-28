resource "netbox_prefix" "bell" {
  prefix        = "192.168.2.0/24"
  status        = "active"
  description   = "Bell Home Hub network"
  mark_utilized = true
}

resource "netbox_prefix" "current" {
  prefix        = "192.168.1.0/24"
  status        = "active"
  description   = "Current home network"
  mark_utilized = true
}

resource "netbox_prefix" "home" {
  prefix      = "10.0.0.0/8"
  status      = "active"
  description = "Home network"
}

resource "netbox_prefix" "kubernetes_nodes" {
  prefix      = "10.8.1.0/24"
  status      = "active"
  description = "Kubernetes nodes"
}

resource "netbox_prefix" "cluster_internal_pods" {
  prefix        = "10.244.0.0/16"
  status        = "reserved"
  description   = "Kubernetes cluster internal - pods"
  mark_utilized = true
}

resource "netbox_prefix" "cluster_internal_services" {
  prefix        = "10.96.0.0/12"
  status        = "reserved"
  description   = "Kubernetes cluster internal - services"
  mark_utilized = true
}

resource "netbox_prefix" "cluster_load_balancers" {
  prefix        = "10.8.240.0/20"
  status        = "active"
  description   = "Kubernetes cluster load balancers"
  mark_utilized = true
}
