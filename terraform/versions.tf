terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.11.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.2.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.3.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.29.2"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.25.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.13.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.4.1"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "1.9.5"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.113.1"
    }
    coderd = {
      source  = "coder/coderd"
      version = "0.0.25"
    }
  }
}
