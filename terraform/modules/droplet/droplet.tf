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
}

resource "digitalocean_reserved_ip" "ip" {
  count = var.use_static_ip ? 1 : 0

  region     = var.region
  droplet_id = digitalocean_droplet.droplet.id
}
