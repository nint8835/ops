resource "cloudflare_record" "host" {
  zone_id = var.zone_id

  name  = "${var.name}.${var.subdomain}"
  type  = "A"
  value = var.ip
}

resource "cloudflare_record" "host_lb" {
  zone_id = var.zone_id

  name  = var.subdomain
  type  = "A"
  value = var.ip
}
