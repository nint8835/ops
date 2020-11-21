terraform {
  backend "remote" {
    organization = "bootleg-technology"

    workspaces {
      name = "ops-bootleg-technology"
    }
  }
}

module "env" {
  source              = "./modules/env"
  vault_access_token  = var.vault_access_token
  vault_address       = var.vault_address
  github_organization = "bootleg-technology"

  github_users = {
    "nint8835" = ["security_admin", "kv_admin"]
  }
}
