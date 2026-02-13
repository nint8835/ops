terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.10.1"
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
      version = "0.27.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.75.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.16.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.11.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.2.1"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "1.7.6"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.95.0"
    }
    netbox = {
      source  = "e-breuninger/netbox"
      version = "5.1.0"
    }
    coderd = {
      source  = "coder/coderd"
      version = "0.0.13"
    }
  }
}
