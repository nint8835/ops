terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.8.0"
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
      version = "0.19.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.51.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.3.0"
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
      version = "1.5.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
    harbor = {
      source  = "goharbor/harbor"
      version = "3.10.20"
    }
  }
}
