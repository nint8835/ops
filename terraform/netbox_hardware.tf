resource "netbox_manufacturer" "ubiquiti" {
  name = "Ubiquiti"
  slug = "ubiquiti"
}

resource "netbox_manufacturer" "startech" {
  name = "StarTech"
  slug = "startech"
}

resource "netbox_manufacturer" "synology" {
  name = "Synology"
  slug = "synology"
}

resource "netbox_manufacturer" "philips" {
  name = "Philips"
  slug = "philips"
}

resource "netbox_manufacturer" "raspberry_pi" {
  name = "Raspberry Pi"
  slug = "raspberry-pi"
}

resource "netbox_manufacturer" "dell" {
  name = "Dell"
  slug = "dell"
}

resource "netbox_manufacturer" "lenovo" {
  name = "Lenovo"
  slug = "lenovo"
}

resource "netbox_manufacturer" "nabu_casa" {
  name = "Nabu Casa"
  slug = "nabu-casa"
}

resource "netbox_device_role" "router" {
  name = "Router"
  slug = "router"
  # TODO: Less eye-searing colour
  color_hex = "0000ff"
}

resource "netbox_device_role" "pdu" {
  name = "Power Distribution Unit"
  slug = "pdu"
  # TODO: Less eye-searing colour
  color_hex = "ff0000"
}

resource "netbox_device_role" "shelf" {
  name = "Shelf"
  slug = "shelf"
  # TODO: Less eye-searing colour
  color_hex = "ffff00"
}

resource "netbox_device_role" "switch" {
  name = "Switch"
  slug = "switch"
  # TODO: Less eye-searing colour
  color_hex = "00ff00"
}

resource "netbox_device_role" "nas" {
  name = "Network Attached Storage"
  slug = "nas"
  # TODO: Less eye-searing colour
  color_hex = "ff00ff"
}

resource "netbox_device_role" "access_point" {
  name = "Access Point"
  slug = "access-point"
  # TODO: Less eye-searing colour
  color_hex = "00ffff"
}

resource "netbox_device_role" "server" {
  name = "Server"
  slug = "server"
  # TODO: Less eye-searing colour
  color_hex = "ffa500"
}

resource "netbox_rack" "living_room" {
  name        = "Living Room"
  location_id = netbox_location.living_room.id
  site_id     = netbox_site.home.id
  status      = "active"
  u_height    = 15
  width       = 19
}

resource "netbox_device_type" "startech_pdu" {
  manufacturer_id = netbox_manufacturer.startech.id
  model           = "8 Outlet Horizontal 1U Rack Mount PDU"
  slug            = "startech-pdu"
  part_number     = "RKPW081915"
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

resource "netbox_device_type" "udm_pro" {
  manufacturer_id = netbox_manufacturer.ubiquiti.id
  model           = "Dream Machine Pro"
  slug            = "udm-pro"
  part_number     = "UDM-Pro"
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
  u_height       = 5
  subdevice_role = "parent"
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

resource "netbox_device_type" "ds920_plus" {
  manufacturer_id = netbox_manufacturer.synology.id
  model           = "DS920+"
  slug            = "ds920-plus"
  part_number     = "DS920+"
  subdevice_role  = "child"
  u_height        = 0
}

resource "netbox_device" "nas" {
  name           = "Mnemosyne"
  site_id        = netbox_site.home.id
  location_id    = netbox_location.living_room.id
  device_type_id = netbox_device_type.ds920_plus.id
  rack_id        = netbox_rack.living_room.id
  role_id        = netbox_device_role.nas.id
  rack_position  = 0
}

resource "netbox_device_type" "nano_hd" {
  manufacturer_id = netbox_manufacturer.ubiquiti.id
  model           = "nanoHD"
  slug            = "nano-hd"
  part_number     = "UAP-nanoHD"
  subdevice_role  = "child"
  u_height        = 0
}

resource "netbox_device" "nano_hd" {
  name           = "Living Room AP"
  site_id        = netbox_site.home.id
  location_id    = netbox_location.living_room.id
  device_type_id = netbox_device_type.nano_hd.id
  rack_id        = netbox_rack.living_room.id
  role_id        = netbox_device_role.access_point.id
  rack_position  = 0
}

resource "netbox_device_type" "hue_bridge" {
  manufacturer_id = netbox_manufacturer.philips.id
  model           = "Hue Bridge"
  slug            = "hue-bridge"
  part_number     = "3241312018A"
  subdevice_role  = "child"
  u_height        = 0
}

resource "netbox_device_role" "misc" {
  name = "Miscellaneous"
  slug = "misc"
  # TODO: Less eye-searing colour
  color_hex = "808080"
}

resource "netbox_device" "hue_bridge" {
  name           = "Hue Bridge"
  site_id        = netbox_site.home.id
  location_id    = netbox_location.living_room.id
  device_type_id = netbox_device_type.hue_bridge.id
  rack_id        = netbox_rack.living_room.id
  role_id        = netbox_device_role.misc.id
  rack_position  = 0
}

resource "netbox_device_type" "pi_b" {
  manufacturer_id = netbox_manufacturer.raspberry_pi.id
  model           = "Raspberry Pi Model B"
  slug            = "raspberry-pi-b"
  part_number     = "Raspberry Pi Model B"
  subdevice_role  = "child"
  u_height        = 0
}

resource "netbox_device" "proxmox_proxy" {
  name           = "proxmox-proxy"
  site_id        = netbox_site.home.id
  location_id    = netbox_location.living_room.id
  device_type_id = netbox_device_type.pi_b.id
  rack_id        = netbox_rack.living_room.id
  role_id        = netbox_device_role.server.id
  rack_position  = 0
}

resource "netbox_device_type" "thinkcentre_m715_tiny" {
  manufacturer_id = netbox_manufacturer.lenovo.id
  model           = "ThinkCentre M715 Tiny"
  slug            = "thinkcentre-m715-tiny"
  part_number     = "10VHA00500"
  subdevice_role  = "child"
  u_height        = 0
}

resource "netbox_device_type" "thinkstation_p330_tiny" {
  manufacturer_id = netbox_manufacturer.lenovo.id
  model           = "ThinkStation P330 Tiny"
  slug            = "thinkstation-p330-tiny"
  part_number     = "30CF000KUS"
  subdevice_role  = "child"
  u_height        = 0
}

resource "netbox_device_type" "thinkcentre_m93p_tiny" {
  manufacturer_id = netbox_manufacturer.lenovo.id
  model           = "ThinkCentre M93p Tiny"
  slug            = "thinkcentre-m93p-tiny"
  part_number     = "3238AJ8"
  subdevice_role  = "child"
  u_height        = 0
}

resource "netbox_device_type" "optiplex_3040_micro" {
  manufacturer_id = netbox_manufacturer.dell.id
  model           = "OptiPlex 3040 Micro"
  slug            = "optiplex-3040-micro"
  part_number     = "7R7H1"
  subdevice_role  = "child"
  u_height        = 0
}

locals {
  shelved_devices = [
    netbox_device.nas,
    netbox_device.nano_hd,
    netbox_device.hue_bridge,
    netbox_device.proxmox_proxy,
    module.proxmox_hosts["asteria"].netbox_device,
    module.proxmox_hosts["zeus"].netbox_device,
  ]
  shelved_entries = {
    for idx, device in local.shelved_devices :
    device.name => {
      device_id = device.id
      index     = idx + 1
    }
  }
}

resource "netbox_device_bay" "shelved_devices" {
  for_each = local.shelved_entries

  device_id           = netbox_device.living_room_shelf.id
  installed_device_id = each.value.device_id
  name                = "Shelved device ${each.value.index}"
}

resource "netbox_device_type" "home_assistant_green" {
  manufacturer_id = netbox_manufacturer.nabu_casa.id
  model           = "Home Assistant Green"
  slug            = "home-assistant-green"
  part_number     = "NC-GREEN-1175"
  subdevice_role  = "child"
  u_height        = 0
}

resource "netbox_device" "home_assistant_green" {
  name           = "Home Assistant Green"
  site_id        = netbox_site.home.id
  location_id    = netbox_location.living_room.id
  device_type_id = netbox_device_type.home_assistant_green.id
  rack_id        = netbox_rack.living_room.id
  role_id        = netbox_device_role.server.id
  rack_position  = 0
}

# TODO:
#  - Non-terraformed VMs
#  - Locate colour scheme for device roles that isn't eye-searing (thanks Copilot)
#  - Identify any other fields on objects that need to be populated
