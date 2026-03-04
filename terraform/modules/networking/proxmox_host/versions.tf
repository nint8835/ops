terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 5.0.0"
    }
    netbox = {
      source  = "e-breuninger/netbox"
      version = ">=5.0.0"
    }
  }
}
