locals {
  file_hashes    = { for file in fileset(var.directory, "**") : file => filesha256("${var.directory}/${file}") }
  hashes         = join("\n", sort([for file, hash in local.file_hashes : "${file}:${hash}"]))
  directory_hash = sha256(local.hashes)
}
