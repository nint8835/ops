resource "vault_mount" "kv" {
  path        = "kv"
  type        = "kv-v2"
}
