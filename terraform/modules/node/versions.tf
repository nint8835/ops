terraform {
  required_providers {
    netbox = {
      source  = "e-breuninger/netbox"
      version = ">=3.1.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = ">=0.2.0"
    }
  }
}
