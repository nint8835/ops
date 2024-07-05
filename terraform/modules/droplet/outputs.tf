output "id" {
  value       = digitalocean_droplet.droplet.id
  description = "The ID of the Droplet"
}

output "public_ip" {
  value       = var.use_static_ip ? digitalocean_reserved_ip.ip[0].ip_address : digitalocean_droplet.droplet.ipv4_address
  description = "The public IP address of the Droplet"
}

output "private_ip" {
  value       = digitalocean_droplet.droplet.ipv4_address_private
  description = "The private IP address of the Droplet"
}
