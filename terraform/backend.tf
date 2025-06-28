terraform {
  cloud {
    hostname     = "bootleg-technology.scalr.io"
    organization = "Infrastructure"

    workspaces {
      name = "ops"
    }
  }
}
