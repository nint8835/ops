terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = ">= 0.2.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.85.0"
    }
  }
}
