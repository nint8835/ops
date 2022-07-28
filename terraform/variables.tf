variable "proxmox_url" {
  type    = string
  default = "https://192.168.1.15:8006/api2/json"
}

variable "proxmox_username" {
  type    = string
  default = "terraform@pve!terraform"
}

variable "proxmox_token_id" {
  type    = string
  default = "terraform"
}

variable "proxmox_token" {
  type = string
}
