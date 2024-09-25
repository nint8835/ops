terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.31.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.14.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.16.1"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.39.2"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.3"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.36.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.2.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "1.3.0"
    }
  }
}
