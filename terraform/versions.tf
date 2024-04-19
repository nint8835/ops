terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.27.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.13.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.15.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.36.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.2"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.29.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.2.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "1.2.3"
    }
  }
}
