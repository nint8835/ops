data "http" "ip_resp" {
  url = "https://ipv4.icanhazip.com"
}

# TODO: non-hardcoded service list
# TODO: static IP?
module "bastion_host" {
  source = "./modules/droplet"

  name   = "bastion"
  vcpus  = 1
  memory = 1024

  userdata = templatefile(
    "${path.module}/templates/bastion_userdata.sh.tmpl",
    {
      tailscale_token = tailscale_tailnet_key.droplet.key
    }
  )

  ingress_rules = [
    {
      protocol         = "tcp"
      port_range       = "22",
      source_addresses = ["${chomp(data.http.ip_resp.body)}/32"]
    },
    {
      protocol         = "tcp"
      port_range       = "80"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "443"
      source_addresses = ["0.0.0.0/0", "::/0"]
    }
  ]
}
