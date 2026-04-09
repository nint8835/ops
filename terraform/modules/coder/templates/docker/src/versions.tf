terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "2.15.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.1.0"
    }
  }
}
