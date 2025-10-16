terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.22.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.68.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.11.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "1.7.3"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.85.1"
    }
    netbox = {
      source  = "e-breuninger/netbox"
      version = "5.0.0"
    }
  }
}
