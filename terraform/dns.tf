data "cloudflare_zone" "bootleg_technology" {
  filter = {
    name = "bootleg.technology"
  }
}

data "cloudflare_zone" "nit_so" {
  filter = {
    name = "nit.so"
  }
}

resource "cloudflare_dns_record" "pkg_nit_so" {
  zone_id = data.cloudflare_zone.nit_so.zone_id
  name    = "pkg"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "miniflux" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "miniflux"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "shopkeeper" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "shopkeeper"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "homeassistant" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "homeassistant"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "skyline" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "skyline"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "scribe" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "scribe"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "interruption_spotter" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "interruption-spotter"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "calibre" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "calibre"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "pollster" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "pollster"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "plex" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "plex"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "flux-webhook-receiver" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "flux-webhook-receiver.ops"
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}
