terraform {
  required_version = ">= 1.13.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.73.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.6.3"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.12.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.3.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.30.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.29.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.13.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.4.2"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "1.10.1"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.123.1"
    }
  }
}
