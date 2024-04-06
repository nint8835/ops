terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.13.7"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.28.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.3.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.7.1"
    }
    github = {
      source  = "integrations/github"
      version = "5.33.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "1.0.1"
    }
  }
}
