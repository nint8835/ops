locals {
  proxied_ports = {
    traefik-http = {
      source_port = 80
      dest_addr   = "10.8.240.0:80"
    }
    traefik-https = {
      source_port = 443
      dest_addr   = "10.8.240.0:443"
    }
  }
}

data "http" "ip_resp" {
  url = "https://ipv4.icanhazip.com"
}

module "bastion_host" {
  source = "./modules/droplet"

  name   = "bastion"
  vcpus  = 1
  memory = 1024
  # Set to 12, but actually running 11
  # Done due to DigitalOcean removing the images for 11. Remove lifecycle ignore within module when ready to upgrade
  distribution_version = "12 x64"

  userdata = templatefile(
    "${path.module}/templates/bastion_userdata.sh.tmpl",
    {
      tailscale_token = tailscale_tailnet_key.droplet.key
      caddy_config = jsonencode({
        apps = {
          layer4 = {
            servers = { for k, v in local.proxied_ports : k => {
              listen = [":${v.source_port}"]
              routes = [{
                handle = [{
                  handler        = "proxy"
                  proxy_protocol = "v2"
                  upstreams = [{
                    dial = [v.dest_addr]
                  }]
                }]
              }]
              }
            }
          }
        }
      })
    }
  )

  use_static_ip = true
  ingress_rules = [
    {
      protocol         = "tcp"
      port_range       = "22",
      source_addresses = ["${chomp(data.http.ip_resp.response_body)}/32"]
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

resource "cloudflare_dns_record" "bastion" {
  zone_id = data.cloudflare_zone.bootleg_technology.zone_id
  name    = "ingress.bootleg.technology"
  content = module.bastion_host.public_ip
  type    = "A"
  ttl     = 1
}

locals {
  bastion_hostname = cloudflare_dns_record.bastion.name
}
