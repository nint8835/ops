terraform {
  required_version = ">= 1.12.0, < 2.0.0"

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
