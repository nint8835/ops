resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.name
  node_name = var.host_name

  reboot_after_update = false

  scsi_hardware = "virtio-scsi-single"

  agent {
    enabled = false
  }

  cpu {
    cores   = 2
    sockets = 1
    type    = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.role == "controlplane" ? 4096 : 8192
  }

  disk {
    interface = "scsi0"
    size      = 80
    iothread  = true
  }

  operating_system {
    type = "l26"
  }

  network_device {
    vlan_id  = 8
    firewall = true
  }
}

resource "proxmox_virtual_environment_pool_membership" "pool" {
  vm_id   = proxmox_virtual_environment_vm.vm.id
  pool_id = var.proxmox_pool_id
}

resource "netbox_virtual_machine" "vm" {
  name         = var.name
  cluster_id   = var.netbox_cluster_id
  device_id    = var.host_device_id
  site_id      = var.netbox_site_id
  memory_mb    = proxmox_virtual_environment_vm.vm.memory[0].dedicated / 1024 * 1000
  vcpus        = proxmox_virtual_environment_vm.vm.cpu[0].cores * proxmox_virtual_environment_vm.vm.cpu[0].sockets
  disk_size_mb = proxmox_virtual_environment_vm.vm.disk[0].size * 1000
}

resource "netbox_interface" "net0" {
  name               = "net0"
  virtual_machine_id = netbox_virtual_machine.vm.id
}

resource "netbox_ip_address" "ip" {
  ip_address                   = "${var.ip}/32"
  description                  = var.name
  status                       = "active"
  virtual_machine_interface_id = netbox_interface.net0.id
}

resource "netbox_primary_ip" "ip" {
  virtual_machine_id = netbox_virtual_machine.vm.id
  ip_address_id      = netbox_ip_address.ip.id
}
