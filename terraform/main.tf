resource "proxmox_vm_qemu" "packer-test" {
  name        = "packer-test"
  desc        = "Packer test VM"
  target_node = "zeus"

  clone = "ubuntu-2204"

  #  pool = "pool0"

  #  storage = "local"
  cores   = 1
  sockets = 1
  memory  = 512
  disk_gb = 10
  nic     = "virtio"
  bridge  = "vmbr0"

  os_type = "cloud-init"

  sshkeys = <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDrjjGunzOVNLC9trokTJLKRo6K3Pi/Fo7XVkVZrq8mLIGuUfhLcDZvHVQCEFOE5v/vj7Z99renW7tiWrFJWoXipP4l+pjb1qsbeASSYrDSImtI+k3LBG71EOOsUPqb4Rhk6dpGfuT4+Dx5LLc3bRYqqtmpAbOEUxozw/M0V0pQO8a5tFaYLOn+kJDBwmYZp4bHLv7793mDOuR1tXH2pGzEphi5toCOiDnlaOvYhlvN4yiZD0eGpJ/4XGuefk191vmTX9/NtN2cvRRvkXsWqso4TfHRTgnnzYgpOFNmJiVYLqFSEB5mj6f973WM0pPIzd7BmjHIDwLdezJ17k3gJ2+KHCACRzPac5XPbdR6oZcPLCOA0D1cnACzEZf6hzBEYuN5l2PSyNltAHE4qgW9KPSR+K4WdAzCDITXuSZIUszd8mY68HgCDyDDorQYwnnCcHBuWroqb+DPYgztsP1tEcTwL26g1/8Io/jvexsPZ63PHpCtq4k29FKTvEkFoB1+Xc= nint8835@Rileys-MacBook-Pro.local
EOF
}
