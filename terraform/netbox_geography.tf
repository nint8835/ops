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
