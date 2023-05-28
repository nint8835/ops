module "devices_vlan" {
  source = "./modules/networking/vlan"

  name          = "Devices"
  tag           = 2
  cidr_block    = "10.0.0.0/16"
  mark_utilized = true
}

module "kubernetes_vlan" {
  source = "./modules/networking/vlan"

  name       = "Kubernetes"
  tag        = 8
  cidr_block = "10.8.0.0/16"
}
