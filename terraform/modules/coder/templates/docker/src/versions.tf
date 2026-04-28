terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "2.16.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.2.0"
    }
  }
}
