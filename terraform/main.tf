module "vault_base" {
  source = "./modules/vault_base"

  github_organization = "bootleg-technology"
  github_users = {
    "nint8835" = ["security_admin", "kv_admin"]
  }
}

module "bastion_host" {
  source = "./modules/droplet"

  name   = "cerberus"
  memory = 1024
  vcpus  = 1
}
