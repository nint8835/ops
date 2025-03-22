variable "namespace" {
  description = "Kubernetes namespace to run in"
  type        = string
}

variable "router_name" {
  description = "Name of the router to create. Will be used as the machine name in Tailscale, as well as the name of resources in Kubernetes."
  type        = string
}

variable "routes" {
  description = "Routes to handle routing from."
  type        = list(string)
}

variable "ts_auth_key_secret" {
  description = "Name of the Kubernetes secret containing the Tailscale auth key."
  type        = string
}

variable "router_group" {
  description = "A unique label to group multiple instances of this same router. Used for scheduling."
  type        = string
}
