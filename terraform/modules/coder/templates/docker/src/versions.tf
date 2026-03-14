terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "2.14.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}
