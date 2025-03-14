terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.18.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.49.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.5"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.1.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "1.5.1"
    }
  }
}
