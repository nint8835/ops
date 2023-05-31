output "id" {
  value = digitalocean_droplet.droplet.id
}

output "public_ip" {
  value = var.use_static_ip ? digitalocean_reserved_ip.ip[0].ip_address : digitalocean_droplet.droplet.ipv4_address
}

output "private_ip" {
  value = digitalocean_droplet.droplet.ipv4_address_private
}
