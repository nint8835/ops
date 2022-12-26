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
