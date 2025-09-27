
data "cloudflare_zones" "zones" {}

locals {
  zone_ids = { for z in data.cloudflare_zones.zones.result : z.name => z.id }
}

resource "cloudflare_dns_record" "pkg_nit_so" {
  zone_id = local.zone_ids["nit.so"]
  name    = "pkg.nit.so"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "miniflux" {
  zone_id = local.zone_ids["bootleg.technology"]
  name    = "miniflux.bootleg.technology"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "shopkeeper" {
  zone_id = local.zone_ids["bootleg.technology"]
  name    = "shopkeeper.bootleg.technology"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "homeassistant" {
  zone_id = local.zone_ids["bootleg.technology"]
  name    = "homeassistant.bootleg.technology"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "skyline" {
  zone_id = local.zone_ids["bootleg.technology"]
  name    = "skyline.bootleg.technology"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "scribe" {
  zone_id = local.zone_ids["bootleg.technology"]
  name    = "scribe.bootleg.technology"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "interruption_spotter" {
  zone_id = local.zone_ids["bootleg.technology"]
  name    = "interruption-spotter.bootleg.technology"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "calibre" {
  zone_id = local.zone_ids["bootleg.technology"]
  name    = "calibre.bootleg.technology"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "pollster" {
  zone_id = local.zone_ids["bootleg.technology"]
  name    = "pollster.bootleg.technology"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "plex" {
  zone_id = local.zone_ids["bootleg.technology"]
  name    = "plex.bootleg.technology"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "flux_webhook_receiver" {
  zone_id = local.zone_ids["bootleg.technology"]
  name    = "flux-webhook-receiver.ops.bootleg.technology"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "photos" {
  zone_id = local.zone_ids["rileyflynn.me"]
  name    = "photos.rileyflynn.me"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "paperless" {
  zone_id = local.zone_ids["bootleg.technology"]
  name    = "paperless.bootleg.technology"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "grafana" {
  zone_id = local.zone_ids["bootleg.technology"]
  name    = "grafana.ops.bootleg.technology"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "traefik_dashboard" {
  zone_id = local.zone_ids["bootleg.technology"]
  name    = "traefik.ops.bootleg.technology"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}
