terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "2.17.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.3.0"
    }
  }
}
