resource "netbox_vlan" "devices" {
  name = "Devices"
  vid  = 2
}

resource "netbox_vlan" "kubernetes" {
  name = "Kubernetes"
  vid  = 8
}