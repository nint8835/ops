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

resource "netbox_ip_address" "ip" {
  ip_address  = "${var.ip}/32"
  description = var.name
  status      = "active"
  dns_name    = "${var.name}.${var.subdomain}"
}
