module "cheesetown_proxy" {
  source = "./modules/droplet"

  name   = "cheesetown-proxy"
  vcpus  = 1
  memory = 1024

  use_static_ip = true
  ingress_rules = [
    {
      protocol         = "tcp"
      port_range       = "22",
      source_addresses = ["${chomp(data.http.ip_resp.body)}/32"]
    },
    {
      protocol         = "tcp"
      port_range       = "25565"
      source_addresses = ["0.0.0.0/0", "::/0"]
    }
  ]
}
