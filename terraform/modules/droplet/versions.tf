terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">=2.28.1"
    }
    netbox = {
      source  = "e-breuninger/netbox"
      version = ">=5.0.0"
    }
  }
}
