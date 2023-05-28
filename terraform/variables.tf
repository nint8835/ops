variable "netbox_url" {
  description = "URL to the NetBox instance to use"
  type        = string
  default     = "http://localhost:8000"
}

variable "netbox_token" {
  description = "API token for NetBox"
  type        = string
}
