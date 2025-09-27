
data "cloudflare_zones" "zones" {}

locals {
  zone_ids = { for z in data.cloudflare_zones.zones.result : z.name => z.id }

  ingress_domains = [
    "calibre.bootleg.technology",
    "flux-webhook-receiver.ops.bootleg.technology",
    "grafana.ops.bootleg.technology",
    "homeassistant.bootleg.technology",
    "interruption-spotter.bootleg.technology",
    "miniflux.bootleg.technology",
    "paperless.bootleg.technology",
    "photos.rileyflynn.me",
    "pkg.nit.so",
    "plex.bootleg.technology",
    "pollster.bootleg.technology",
    "scribe.bootleg.technology",
    "shopkeeper.bootleg.technology",
    "skyline.bootleg.technology",
    "traefik.ops.bootleg.technology",
  ]

  ingress_entries = {
    for domain in local.ingress_domains : domain => {
      zone_id = local.zone_ids[regex("\\.(\\w+\\.\\w+)$", domain)[0]]
      name    = domain
    }
  }
}

resource "cloudflare_dns_record" "ingress" {
  for_each = local.ingress_entries

  zone_id = each.value.zone_id
  name    = each.value.name
  content = local.bastion_hostname
  type    = "CNAME"
  ttl     = 1
}
