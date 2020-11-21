data "vault_policy_document" "security_admin" {
  rule {
    path         = "auth/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
  }

  rule {
    path         = "sys/auth/*"
    capabilities = ["create", "update", "delete", "sudo"]
  }

  rule {
    path         = "sys/auth"
    capabilities = ["read"]
  }

  rule {
    path         = "sys/policies/acl"
    capabilities = ["list"]
  }

  rule {
    path         = "sys/policies/acl/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
  }

  rule {
    path         = "secret/*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
  }

  rule {
    path         = "sys/mounts*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
  }

  rule {
    path         = "sys/health"
    capabilities = ["read", "sudo"]
  }
}

resource "vault_policy" "security_admin" {
  name   = "security_admin"
  policy = data.vault_policy_document.security_admin.hcl
}

data "vault_policy_document" "kv_admin" {
  rule {
    path         = "kv/"
    capabilities = ["list"]
  }

  rule {
    path         = "kv/*"
    capabilities = ["create", "read", "update", "delete", "list"]
  }
}

resource "vault_policy" "kv_admin" {
  name   = "kv_admin"
  policy = data.vault_policy_document.kv_admin.hcl
}
