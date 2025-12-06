terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.24.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.70.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.13.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.9.0"
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
      version = "0.88.0"
    }
    netbox = {
      source  = "e-breuninger/netbox"
      version = "5.0.0"
    }
  }
}
