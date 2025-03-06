data "cloudflare_zone" "bootleg_technology" {
  name = "bootleg.technology"
}

data "cloudflare_zone" "nit_so" {
  name = "nit.so"
}

resource "cloudflare_record" "pkg_nit_so" {
  zone_id = data.cloudflare_zone.nit_so.zone_id
  name    = "pkg"
  content = cloudflare_record.bastion.hostname
  type    = "CNAME"
}

resource "cloudflare_record" "miniflux" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "miniflux"
  content = cloudflare_record.bastion.hostname
  type    = "CNAME"
}

resource "cloudflare_record" "shopkeeper" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "shopkeeper"
  content = cloudflare_record.bastion.hostname
  type    = "CNAME"
}

resource "cloudflare_record" "homeassistant" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "homeassistant"
  content = cloudflare_record.bastion.hostname
  type    = "CNAME"
}

resource "cloudflare_record" "skyline" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "skyline"
  content = cloudflare_record.bastion.hostname
  type    = "CNAME"
}

resource "cloudflare_record" "scribe" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "scribe"
  content = cloudflare_record.bastion.hostname
  type    = "CNAME"
}

resource "cloudflare_record" "interruption_spotter" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "interruption-spotter"
  content = cloudflare_record.bastion.hostname
  type    = "CNAME"
}

resource "cloudflare_record" "calibre" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "calibre"
  content = cloudflare_record.bastion.hostname
  type    = "CNAME"
}

resource "cloudflare_record" "pollster" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "pollster"
  content = cloudflare_record.bastion.hostname
  type    = "CNAME"
}

resource "cloudflare_record" "plex" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "plex"
  content = cloudflare_record.bastion.hostname
  type    = "CNAME"
}
