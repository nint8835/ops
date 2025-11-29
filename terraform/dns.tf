
data "cloudflare_zones" "zones" {}

locals {
  zone_ids = { for z in data.cloudflare_zones.zones.result : z.name => z.id }

  ingress_domains = [
    "calibre.bootleg.technology",
    "flux-webhook-receiver.ops.bootleg.technology",
    "grafana.ops.bootleg.technology",
    "homeassistant.bootleg.technology",
    "interruption-spotter.bootleg.technology",
    "llm.ops.bootleg.technology",
    "miniflux.bootleg.technology",
    "netbox.ops.bootleg.technology",
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

resource "cloudflare_dns_record" "bastion" {
  zone_id = local.zone_ids["bootleg.technology"]
  name    = "ingress.bootleg.technology"
  type    = "A"
  ttl     = 1

  lifecycle {
    ignore_changes = [
      # Managed by cloudflare-ddns
      content
    ]
  }
}

resource "cloudflare_dns_record" "ingress" {
  for_each = local.ingress_entries

  zone_id = each.value.zone_id
  name    = each.value.name
  content = cloudflare_dns_record.bastion.name
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "cluster" {
  for_each = local.control_plane_nodes

  zone_id = local.zone_ids["bootleg.technology"]
  name    = "cluster.ops.bootleg.technology"
  content = each.value.ip
  type    = "A"
  ttl     = 1
}

resource "cloudflare_dns_record" "proxmox_proxy_internal" {
  zone_id = local.zone_ids["bootleg.technology"]
  name    = "proxy.hosts.bootleg.technology"
  content = "192.168.1.181"
  type    = "A"
  ttl     = 1
}

resource "cloudflare_dns_record" "proxmox_proxy_tailscale" {
  zone_id = local.zone_ids["bootleg.technology"]
  name    = "proxy-tailscale.hosts.bootleg.technology"
  content = "100.91.221.13"
  type    = "A"
  ttl     = 1
}

resource "cloudflare_dns_record" "mnemosyne" {
  for_each = toset(["192.168.1.210", "192.168.1.213"])

  zone_id = local.zone_ids["bootleg.technology"]
  name    = "mnemosyne.internal.bootleg.technology"
  content = each.value
  type    = "A"
  ttl     = 1
}

resource "cloudflare_dns_record" "ares" {
  zone_id = local.zone_ids["bootleg.technology"]
  name    = "ares.internal.bootleg.technology"
  content = "192.168.1.177"
  type    = "A"
  ttl     = 1
}

resource "cloudflare_dns_record" "ares_cname" {
  for_each = toset([
    "llama.internal.bootleg.technology",
    "llm.internal.bootleg.technology",
  ])

  zone_id = local.zone_ids["bootleg.technology"]
  name    = each.value
  content = cloudflare_dns_record.ares.name
  type    = "CNAME"
  ttl     = 1
}
