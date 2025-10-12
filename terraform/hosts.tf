locals {
  proxmox_hosts = {
    aphrodite = {
      ip             = "192.168.1.178"
      device_type_id = netbox_device_type.optiplex_3040_micro.id
    }
    apollo = {
      ip             = "192.168.1.220"
      device_type_id = netbox_device_type.optiplex_3040_micro.id
    }
    asteria = {
      ip             = "192.168.1.231"
      device_type_id = netbox_device_type.thinkcentre_m715_tiny.id
    }
    astraeus = {
      ip             = "192.168.1.100"
      device_type_id = netbox_device_type.thinkstation_p330_tiny.id
    }
    eos = {
      ip             = "192.168.1.40"
      device_type_id = netbox_device_type.thinkstation_p330_tiny.id
    }
    helios = {
      ip             = "192.168.1.101"
      device_type_id = netbox_device_type.thinkstation_p330_tiny.id
    }
    selene = {
      ip             = "192.168.1.103"
      device_type_id = netbox_device_type.thinkstation_p330_tiny.id
    }
    titan = {
      ip             = "192.168.1.104"
      device_type_id = netbox_device_type.thinkstation_p330_tiny.id
    }
    zeus = {
      ip             = "192.168.1.155"
      device_type_id = netbox_device_type.thinkcentre_m93p_tiny.id
    }
  }
}

module "proxmox_hosts" {
  for_each = local.proxmox_hosts

  source = "./modules/networking/proxmox_host"

  name           = each.key
  ip             = each.value.ip
  device_type_id = each.value.device_type_id

  zone_id = local.zone_ids["bootleg.technology"]

  cluster_id  = netbox_cluster.hera.id
  location_id = netbox_location.living_room.id
  rack_id     = netbox_rack.living_room.id
  role_id     = netbox_device_role.server.id
  site_id     = netbox_site.home.id
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
