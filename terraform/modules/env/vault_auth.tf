resource "vault_github_auth_backend" "github" {
  organization = var.github_organization
}

resource "vault_github_user" "user" {
  for_each = var.github_users

  backend  = vault_github_auth_backend.github.id
  user     = each.key
  policies = each.value
}
