resource "cloudflare_dns_record" "host" {
  zone_id = var.zone_id

  name    = "${var.name}.${var.subdomain}"
  type    = "A"
  content = var.ip
  ttl     = 1
}

resource "cloudflare_dns_record" "host_lb" {
  zone_id = var.zone_id

  name    = var.subdomain
  type    = "A"
  content = var.ip
  ttl     = 1
}

resource "netbox_device" "device" {
  name           = var.name
  site_id        = var.site_id
  location_id    = var.location_id
  device_type_id = var.device_type_id
  rack_id        = var.rack_id
  role_id        = var.role_id
  rack_position  = var.rack_position
  cluster_id     = var.cluster_id
}

resource "netbox_device_interface" "ethernet" {
  device_id = netbox_device.device.id
  name      = "Ethernet"
  enabled   = true
  type      = "1000base-t"
}

resource "netbox_ip_address" "ip" {
  ip_address          = "${var.ip}/32"
  description         = var.name
  status              = "active"
  dns_name            = "${var.name}.${var.subdomain}"
  device_interface_id = netbox_device_interface.ethernet.id
}

resource "netbox_device_primary_ip" "ip" {
  device_id     = netbox_device.device.id
  ip_address_id = netbox_ip_address.ip.id
}
