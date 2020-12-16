terraform {
  backend "remote" {
    organization = "bootleg-technology"

    workspaces {
      name = "ops-bootleg-technology"
    }
  }
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_access_token
}

module "vault_base" {
  source              = "./modules/vault_base"

  github_organization = "bootleg-technology"
  github_users = {
    "nint8835" = ["security_admin", "kv_admin"]
  }
}
