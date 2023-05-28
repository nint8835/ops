resource "netbox_vlan" "vlan" {
  name = var.name
  vid  = var.tag
}