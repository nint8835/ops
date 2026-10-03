language {
  edition = experimental2026
}

function "hash_directory" {
  description = "Hash sorted relative file names and SHA-256 contents of a directory."
  type        = string

  parameter "directory" {
    type = string
  }

  locals {
    file_hashes = { for file in fileset(param.directory, "**") : file => filesha256("${param.directory}/${file}") }
    hashes      = join("\n", sort([for file, hash in local.file_hashes : "${file}:${hash}"]))
  }

  return = sha256(local.hashes)
}
