locals {
  proxmox_hosts = {
    aphrodite = {
      ip = "192.168.1.178"
    }
    apollo = {
      ip = "192.168.1.220"
    }
    asteria = {
      ip = "192.168.1.231"
    }
    astraeus = {
      ip = "192.168.1.100"
    }
    eos = {
      ip = "192.168.1.40"
    }
    helios = {
      ip = "192.168.1.101"
    }
    selene = {
      ip = "192.168.1.103"
    }
    titan = {
      ip = "192.168.1.104"
    }
    zeus = {
      ip = "192.168.1.155"
    }
  }
}

module "proxmox_hosts" {
  for_each = local.proxmox_hosts

  source = "./modules/networking/proxmox_host"

  name = each.key
  ip   = each.value.ip

  zone_id = local.zone_ids["bootleg.technology"]
}
