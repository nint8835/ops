variable "name" {
  description = "Name for the registry to mirror in Harbor"
  type        = string
}

variable "registry_url" {
  description = "URL of the registry to mirror"
  type        = string
}

variable "provider_name" {
  description = "Name of the provider of this registry"
  type        = string
}
