terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = ">=0.2.0"
    }
    netbox = {
      source  = "e-breuninger/netbox"
      version = ">=5.0.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.87.0"
    }
  }
}
