locals {
  proxmox_hosts = {
    aphrodite = "192.168.1.178"
    apollo    = "192.168.1.220"
    asteria   = "192.168.1.231"
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
  zone_id = local.zone_ids["bootleg.technology"]
}

resource "netbox_cluster_type" "proxmox" {
  name = "Proxmox VE"
  slug = "proxmox-ve"
}

resource "netbox_cluster" "hera" {
  name            = "Hera"
  cluster_type_id = netbox_cluster_type.proxmox.id
  site_id         = netbox_site.home.id
}
