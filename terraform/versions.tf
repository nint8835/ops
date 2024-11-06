terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.33.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.17.2"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.43.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.5"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.45.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.3.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "1.4.0"
    }
  }
}
