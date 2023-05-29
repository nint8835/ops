resource "digitalocean_firewall" "droplet_firewall" {
  # Only create a firewall if ingress rules are provided.
  count = min(length(var.ingress_rules), 1)

  name = "${var.name}-firewall"

  droplet_ids = [digitalocean_droplet.droplet.id]

  dynamic "inbound_rule" {
    for_each = var.ingress_rules

    content {
      protocol         = inbound_rule.value["protocol"]
      port_range       = inbound_rule.value["port_range"]
      source_addresses = inbound_rule.value["source_addresses"]
    }
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
