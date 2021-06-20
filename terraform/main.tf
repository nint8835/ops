module "vault_base" {
  source = "./modules/vault_base"

  github_organization = "bootleg-technology"
  github_users = {
    "nint8835" = ["security_admin", "kv_admin"]
  }
}

data "http" "ip_resp" {
  url = "https://ipv4.icanhazip.com"
}

module "bastion_host" {
  source = "./modules/droplet"

  name   = "cerberus"
  memory = 1024
  vcpus  = 1

  ingress_rules = [
    {
      protocol         = "tcp"
      port_range       = "22",
      source_addresses = ["${chomp(data.http.ip_resp.body)}/32"]
    },
    {
      protocol         = "tcp"
      port_range       = "80",
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "443",
      source_addresses = ["0.0.0.0/0", "::/0"]
    }
  ]
}
