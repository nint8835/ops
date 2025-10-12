resource "netbox_ip_address" "gateway" {
  description = "${var.name} gateway"
  status      = "reserved"
  ip_address  = "${cidrhost(var.cidr_block, 1)}/32"
}

resource "netbox_ip_address" "broadcast" {
  description = "${var.name} broadcast"
  status      = "reserved"
  ip_address  = "${cidrhost(var.cidr_block, -1)}/32"
}

resource "netbox_vlan" "vlan" {
  name = var.name
  vid  = var.tag
}

resource "netbox_prefix" "prefix" {
  prefix        = var.cidr_block
  status        = "active"
  description   = var.name
  vlan_id       = netbox_vlan.vlan.id
  mark_utilized = var.mark_utilized
}
