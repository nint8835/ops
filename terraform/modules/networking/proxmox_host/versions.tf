terraform {
  required_providers {
    netbox = {
      source  = "e-breuninger/netbox"
      version = ">=3.1.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">=4.7.1"
    }
  }
}
