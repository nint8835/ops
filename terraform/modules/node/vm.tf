resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.name
  node_name = var.host_name
  pool_id   = var.proxmox_pool_id

  reboot_after_update = false
  on_boot             = true

  scsi_hardware = "virtio-scsi-single"

  # Fix for PVE 9.2.3 breaking overlay networking
  # https://forum.proxmox.com/threads/kubernetes-overlay-networking-breaks-when-upgrading-from-pve-9-1-to-pve-9-2-3.183963/
  kvm_arguments = "-global virtio-net-pci.host_tunnel_csum=off -global virtio-net-pci.csum=off"

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
