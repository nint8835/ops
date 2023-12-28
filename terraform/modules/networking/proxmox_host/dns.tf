resource "cloudflare_record" "host" {
  zone_id = var.zone_id

  name  = "${var.name}.${var.subdomain}"
  type  = "A"
  value = var.ip
}
