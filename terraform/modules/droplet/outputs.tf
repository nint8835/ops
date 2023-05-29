output "id" {
  value = digitalocean_droplet.droplet.id
}

output "public_ip" {
  value = digitalocean_droplet.droplet.ipv4_address
}

output "private_ip" {
  value = digitalocean_droplet.droplet.ipv4_address_private
}
