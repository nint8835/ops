terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.11.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.2"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.29.2"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.19.1"
    }
    github = {
      source  = "integrations/github"
      version = "6.12.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.3.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "1.8.8"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.109.0"
    }
    netbox = {
      source  = "e-breuninger/netbox"
      version = "5.4.0"
    }
    coderd = {
      source  = "coder/coderd"
      version = "0.0.16"
    }
  }
}
