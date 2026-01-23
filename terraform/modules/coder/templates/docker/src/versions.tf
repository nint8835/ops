terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "2.13.1"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.9.0"
    }
  }
}
