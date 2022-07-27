# Ubuntu 22.04 cloud-init Image

## Usage

- Create a new user for Packer (if one doesn't already exist)
  - Use name `packer`
  - Create as a Proxmox VE auth service user
  - Assign a random password (this password won't be used)
- Create a new API token for this user
- Copy `proxmox.pkrvars.hcl.dist` to `proxmox.pkrvars.hcl`
- Populate `proxmox_token` with the token you just generated
- Assign permissions to the user
  - Path: `/`
  - Role: Administrator
  - Propagate: true
  - TODO: Figure out how RBAC in Proxmox works, to not grant so many perms
- Run Packer
  ```shell
  packer build --var-file=proxmox.pkrvars.hcl .
  ```

## Credits

Initial proxmox packer code is taken from [dustinrue/proxmox-packer](https://github.com/dustinrue/proxmox-packer)
