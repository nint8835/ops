terraform {
  backend "remote" {
    organization = "bootleg-technology"

    workspaces {
      name = "ops-bootleg-technology"
    }
  }
}
