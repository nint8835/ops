data "digitalocean_images" "distro_images" {
  filter {
    key    = "distribution"
    values = [var.distribution]
  }
  filter {
    key    = "name"
    values = [var.distribution_version]
  }
  sort {
    key       = "created"
    direction = "desc"
  }
}

data "digitalocean_sizes" "droplet_sizes" {
  filter {
    key    = "regions"
    values = [var.region]
  }
  filter {
    key    = "memory"
    values = [var.memory]
  }
  filter {
    key    = "vcpus"
    values = [var.vcpus]
  }
  sort {
    key       = "price_hourly"
    direction = "asc"
  }
}

data "digitalocean_ssh_keys" "ssh_keys" {}

data "netbox_site" "site" {
  slug = "do-${var.region}"
}

locals {
  ssh_key_ids = length(var.ssh_key_ids) > 0 ? var.ssh_key_ids : data.digitalocean_ssh_keys.ssh_keys.ssh_keys[*].id
}

resource "digitalocean_droplet" "droplet" {
  name      = var.name
  image     = data.digitalocean_images.distro_images.images[0].slug
  region    = var.region
  size      = data.digitalocean_sizes.droplet_sizes.sizes[0].slug
  ssh_keys  = local.ssh_key_ids
  user_data = var.userdata != "" ? var.userdata : null

  lifecycle {
    create_before_destroy = true

    # Tailscale API key rotation requires auth keys to be rotated as well, triggering a change in user_data
    # See if there's a good way to move auth keys out of user_data
    ignore_changes = [user_data]
  }
}

resource "digitalocean_reserved_ip" "ip" {
  count = var.use_static_ip ? 1 : 0

  region     = var.region
  droplet_id = digitalocean_droplet.droplet.id
}

resource "netbox_virtual_machine" "droplet" {
  name         = var.name
  site_id      = data.netbox_site.site.id
  memory_mb    = var.memory
  vcpus        = var.vcpus
  disk_size_mb = data.digitalocean_sizes.droplet_sizes.sizes[0].disk * 1000
}

resource "netbox_interface" "eth0" {
  name               = "eth0"
  virtual_machine_id = netbox_virtual_machine.droplet.id
}

resource "netbox_ip_address" "ipv4" {
  description                  = "${var.name} assigned IPv4"
  ip_address                   = "${digitalocean_droplet.droplet.ipv4_address}/32"
  status                       = "active"
  virtual_machine_interface_id = netbox_interface.eth0.id
}

resource "netbox_ip_address" "reserved" {
  count                        = var.use_static_ip ? 1 : 0
  description                  = "${var.name} reserved static IP"
  ip_address                   = "${digitalocean_reserved_ip.ip[0].ip_address}/32"
  virtual_machine_interface_id = netbox_interface.eth0.id
  status                       = "active"
}

resource "netbox_primary_ip" "primary" {
  virtual_machine_id = netbox_virtual_machine.droplet.id
  ip_address_id      = var.use_static_ip ? netbox_ip_address.reserved[0].id : netbox_ip_address.ipv4.id
}
