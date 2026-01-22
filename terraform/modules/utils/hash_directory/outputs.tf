output "hash" {
  description = "Hash of the directory contents"
  value       = local.directory_hash
}

output "short_hash" {
  description = "Shortened hash of the directory contents"
  value       = substr(local.directory_hash, 0, 8)
}
