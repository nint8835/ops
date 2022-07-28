source "proxmox" "ubuntu_2204" {
  proxmox_url              = var.proxmox_url
  insecure_skip_tls_verify = true
  username                 = var.proxmox_username
  token                    = var.proxmox_token
  node                     = var.proxmox_node

  template_name        = "ubuntu-2204"
  template_description = "Ubuntu 22.04 Server"

  ssh_username = "ubuntu"
  ssh_password = "ubuntu"
  ssh_port     = 22
  ssh_timeout  = "30m"

  os = "l26"

  iso_file    = "${var.proxmox_iso_pool}/${var.iso_name}"
  unmount_iso = true

  http_directory = "cloud-init"
  #  Taken from https://github.com/dbond007/Packer/blob/master/ubuntu_base/variables.22.04.pkr.hcl
  boot_command = [
    "<esc><esc><esc><esc>e<wait>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>",
    "<enter><f10><wait>"
  ]
  boot_wait = "3s"

  cores  = "2"
  memory = "2048"

  scsi_controller = "virtio-scsi-single"
  disks {
    disk_size         = "8G"
    format            = "raw"
    storage_pool      = "local-lvm"
    storage_pool_type = "lvm-thin"
    type              = "scsi"
  }

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }

  #  Attach cloud-init drive to the resulting template
  cloud_init              = true
  cloud_init_storage_pool = "local:iso"
}

build {
  name    = "ubuntu-2204"
  sources = ["source.proxmox.ubuntu_2204"]

  provisioner "shell" {
    inline = [
      "sudo rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg",
      "sudo cloud-init clean",
      "sudo passwd -d ubuntu"
    ]
  }
}
