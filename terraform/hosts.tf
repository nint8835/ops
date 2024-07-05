locals {
  proxmox_hosts = {
    aphrodite = "192.168.1.178"
    apollo    = "192.168.1.220"
    astraeus  = "192.168.1.100"
    eos       = "192.168.1.40"
    helios    = "192.168.1.101"
    selene    = "192.168.1.103"
    titan     = "192.168.1.104"
    zeus      = "192.168.1.155"
  }
}

module "proxmox_hosts" {
  for_each = local.proxmox_hosts

  source = "./modules/networking/proxmox_host"

  name    = each.key
  ip      = each.value
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
}

resource "cloudflare_record" "proxmox_proxy_internal" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "proxy.hosts"
  value   = "192.168.1.181"
  type    = "A"
}

resource "cloudflare_record" "proxmox_proxy_tailscale" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "proxy-tailscale.hosts"
  value   = "100.91.221.13"
  type    = "A"
}
