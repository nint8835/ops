terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.8.1"
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
      version = "0.21.1"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.62.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.7.1"
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
      version = "1.6.4"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.80.0"
    }
  }
}
