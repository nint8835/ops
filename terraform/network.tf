resource "netbox_site_group" "digitalocean" {
  name = "DigitalOcean"
  slug = "digitalocean"
}

resource "netbox_site_group" "self_hosted" {
  name = "Self-Hosted"
  slug = "self-hosted"
}

resource "netbox_region" "canada" {
  name = "Canada"
  slug = "canada"
}

resource "netbox_region" "ontario" {
  name             = "Ontario"
  slug             = "ca-ontario"
  parent_region_id = netbox_region.canada.id
}

resource "netbox_region" "toronto" {
  name             = "Toronto"
  slug             = "ca-ontario-toronto"
  parent_region_id = netbox_region.ontario.id
}

resource "netbox_site" "digitalocean_tor1" {
  name      = "DigitalOcean TOR1"
  slug      = "do-tor1"
  region_id = netbox_region.toronto.id
  group_id  = netbox_site_group.digitalocean.id
  timezone  = "America/Toronto"
}

resource "netbox_region" "newfoundland" {
  name             = "Newfoundland and Labrador"
  slug             = "ca-newfoundland-and-labrador"
  parent_region_id = netbox_region.canada.id
}

resource "netbox_region" "st_johns" {
  name             = "St. John's"
  slug             = "ca-newfoundland-and-labrador-st-johns"
  parent_region_id = netbox_region.newfoundland.id
}

resource "netbox_site" "home" {
  name      = "Home"
  slug      = "home"
  region_id = netbox_region.st_johns.id
  group_id  = netbox_site_group.self_hosted.id
  timezone  = "America/St_Johns"
}

resource "netbox_location" "living_room" {
  name    = "Living Room"
  slug    = "living-room"
  site_id = netbox_site.home.id
}

resource "netbox_rack" "living_room" {
  name        = "Living Room"
  location_id = netbox_location.living_room.id
  site_id     = netbox_site.home.id
  status      = "active"
  u_height    = 15
  width       = 19
}

resource "netbox_manufacturer" "startech" {
  name = "StarTech"
  slug = "startech"
}

resource "netbox_device_type" "startech_pdu" {
  manufacturer_id = netbox_manufacturer.startech.id
  model           = "8 Outlet Horizontal 1U Rack Mount PDU"
  slug            = "startech-pdu"
  part_number     = "RKPW081915"
}

resource "netbox_device_role" "pdu" {
  name = "Power Distribution Unit"
  slug = "pdu"
  # TODO: Less eye-searing colour
  color_hex = "ff0000"
}

resource "netbox_device" "living_room_pdu" {
  name           = "Living Room PDU"
  site_id        = netbox_site.home.id
  location_id    = netbox_location.living_room.id
  device_type_id = netbox_device_type.startech_pdu.id
  rack_id        = netbox_rack.living_room.id
  role_id        = netbox_device_role.pdu.id
  rack_position  = 1
  rack_face      = "front"
}

resource "netbox_manufacturer" "ubiquiti" {
  name = "Ubiquiti"
  slug = "ubiquiti"
}

resource "netbox_device_type" "udm_pro" {
  manufacturer_id = netbox_manufacturer.ubiquiti.id
  model           = "UniFi Dream Machine Pro"
  slug            = "udm-pro"
  part_number     = "UDM-Pro"
}

resource "netbox_device_role" "router" {
  name = "Router"
  slug = "router"
  # TODO: Less eye-searing colour
  color_hex = "0000ff"
}

resource "netbox_device" "udm_pro" {
  name           = "UDM Pro"
  site_id        = netbox_site.home.id
  location_id    = netbox_location.living_room.id
  device_type_id = netbox_device_type.udm_pro.id
  rack_id        = netbox_rack.living_room.id
  role_id        = netbox_device_role.router.id
  rack_position  = 15
  rack_face      = "front"
}

resource "netbox_device_type" "usw_24_poe" {
  manufacturer_id = netbox_manufacturer.ubiquiti.id
  model           = "Standard 24 PoE"
  slug            = "usw-24-poe"
  part_number     = "USW-24-PoE"
}

resource "netbox_device_role" "switch" {
  name = "Switch"
  slug = "switch"
  # TODO: Less eye-searing colour
  color_hex = "00ff00"
}

resource "netbox_device" "usw_24_poe" {
  name           = "USW 24 PoE"
  site_id        = netbox_site.home.id
  location_id    = netbox_location.living_room.id
  device_type_id = netbox_device_type.usw_24_poe.id
  rack_id        = netbox_rack.living_room.id
  role_id        = netbox_device_role.switch.id
  rack_position  = 9
  rack_face      = "front"
}

resource "netbox_device_type" "startech_cantilever_shelf" {
  manufacturer_id = netbox_manufacturer.startech.id
  model           = "1U Server Rack Shelf"
  slug            = "startech-cantilever-shelf"
  part_number     = "CABSHELFV1U"
  # TODO: This'll cause issues if I ever get another one of these that I use for a different U.
  u_height = 5
}

resource "netbox_device_role" "shelf" {
  name = "Shelf"
  slug = "shelf"
  # TODO: Less eye-searing colour
  color_hex = "ffff00"
}

resource "netbox_device" "living_room_shelf" {
  name           = "Living Room Shelf"
  site_id        = netbox_site.home.id
  location_id    = netbox_location.living_room.id
  device_type_id = netbox_device_type.startech_cantilever_shelf.id
  rack_id        = netbox_rack.living_room.id
  role_id        = netbox_device_role.shelf.id
  rack_position  = 10
  rack_face      = "front"
}

resource "netbox_rir" "rfc_1918" {
  name = "RFC 1918"
  slug = "rfc_1918"
}

resource "netbox_aggregate" "ten_dot" {
  prefix = "10.0.0.0/8"
  rir_id = netbox_rir.rfc_1918.id
}

resource "netbox_aggregate" "one_seven_two" {
  prefix = "172.16.0.0/12"
  rir_id = netbox_rir.rfc_1918.id
}

resource "netbox_aggregate" "one_nine_two" {
  prefix = "192.168.0.0/16"
  rir_id = netbox_rir.rfc_1918.id
}

resource "netbox_prefix" "bell" {
  prefix        = "192.168.2.0/24"
  status        = "active"
  description   = "Bell Home Hub network"
  mark_utilized = true
}

resource "netbox_prefix" "current" {
  prefix      = "192.168.1.0/24"
  status      = "active"
  description = "Current home network"
}

resource "netbox_prefix" "home" {
  prefix      = "10.0.0.0/8"
  status      = "active"
  description = "Home network"
}

resource "netbox_prefix" "kubernetes_control_plane" {
  prefix      = "10.8.1.0/24"
  status      = "active"
  description = "Kubernetes nodes - control plane"
}

resource "netbox_prefix" "kubernetes_workers" {
  prefix      = "10.8.2.0/24"
  status      = "active"
  description = "Kubernetes nodes - workers"
}

resource "netbox_prefix" "cluster_internal_pods" {
  prefix        = "10.244.0.0/16"
  status        = "reserved"
  description   = "Kubernetes cluster internal - pods"
  mark_utilized = true
}

resource "netbox_prefix" "cluster_internal_services" {
  prefix        = "10.96.0.0/12"
  status        = "reserved"
  description   = "Kubernetes cluster internal - services"
  mark_utilized = true
}

resource "netbox_prefix" "cluster_load_balancers" {
  prefix        = var.lb_ip_range
  status        = "active"
  description   = "Kubernetes cluster load balancers"
  mark_utilized = true
}

module "kubernetes_vlan" {
  source = "./modules/networking/vlan"

  name       = "Kubernetes"
  tag        = 8
  cidr_block = "10.8.0.0/16"
}

module "virtualization_vlan" {
  source = "./modules/networking/vlan"

  name       = "Virtualization"
  tag        = 6
  cidr_block = "10.6.0.0/16"
}

# TODO: Migrate Proxmox hosts into this CIDR block
resource "netbox_prefix" "proxmox_hosts" {
  prefix        = "10.6.0.0/24"
  status        = "reserved"
  description   = "Proxmox hosts"
  mark_utilized = false
}
