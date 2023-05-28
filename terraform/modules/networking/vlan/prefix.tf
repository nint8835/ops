resource "netbox_prefix" "prefix" {
  prefix        = var.cidr_block
  status        = "active"
  description   = var.name
  vlan_id       = netbox_vlan.vlan.id
  mark_utilized = var.mark_utilized
}