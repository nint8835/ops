data "cloudflare_zone" "bootleg_technology" {
  name = "bootleg.technology"
}

data "cloudflare_zone" "nit_so" {
  name = "nit.so"
}

resource "cloudflare_record" "pkg_nit_so" {
  zone_id = data.cloudflare_zone.nit_so.zone_id
  name    = "pkg"
  value   = module.bastion_host.public_ip
  type    = "A"
}
