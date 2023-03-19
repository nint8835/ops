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

resource "netbox_prefix" "devices" {
  prefix        = "10.0.0.0/16"
  status        = "active"
  description   = "Devices"
  mark_utilized = true
  vlan_id       = netbox_vlan.devices.id
}
