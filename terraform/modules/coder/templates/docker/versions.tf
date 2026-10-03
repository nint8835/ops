terraform {
  required_version = ">= 1.13.0, < 2.0.0"

  required_providers {
    coderd = {
      source  = "coder/coderd"
      version = ">= 0.0.12"
    }
  }
}
