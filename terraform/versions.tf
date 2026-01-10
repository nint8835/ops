terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.10.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.25.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.72.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.15.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.9.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "1.7.6"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.92.0"
    }
    netbox = {
      source  = "e-breuninger/netbox"
      version = "5.0.1"
    }
  }
}
