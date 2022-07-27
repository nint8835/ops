variable "proxmox_node" {
  type    = string
  default = "zeus"
}

variable "proxmox_url" {
  type    = string
  default = "https://192.168.1.15:8006/api2/json"
}

variable "proxmox_username" {
  type    = string
  default = "packer@pve!packer"
}

variable "proxmox_token" {
  type = string
}

variable "template_description" {
  type    = string
  default = "Test template"
}

variable "template_name" {
  type    = string
  default = "Test"
}

variable "proxmox_iso_pool" {
  type    = string
  default = "mnemosyne-isos:iso"
}

variable "iso_name" {
  type    = string
  default = "ubuntu-22.04-live-server-amd64.iso"
}

variable "proxmox_storage_format" {
  type    = string
  default = "raw"
}

variable "proxmox_storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "proxmox_storage_pool_type" {
  type    = string
  default = "lvm-thin"
}
