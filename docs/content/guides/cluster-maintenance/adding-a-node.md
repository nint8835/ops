# Adding a Node

## Create VM

- In Proxmox, create a new VM with the following configuration:
    - Name: `k8s-agent-XX` (where `XX` is the next number in the series)
    - OS:
        - Use CD/DVD disc image file (iso)
        - ISO image: k3OS installation iso
        - Guest OS: Linux 5.x - 2.6 kernel
    - Hard disk size: 60 GiB
    - Cores: 2
    - Memory: 4096 MiB
- Start the VM, and open the console

## Install OS

- On boot, select k3OS installer
- Select the following options:
    - Config system with cloud-init file?: `n`
    - Authorize GitHub users to SSH?: `y`
    - Comma separated list of GitHub users to authorize: `nint8835`
    - Configure WiFi?: `n`
    - Run as server or agent?: `2` (agent)
    - URL of server: `https://192.168.1.74:6443`
    - Token or cluster secret: Cluster secret configured on setup
    - Continue?: `y`
- On reboot, remove the installer ISO from the VM

## Post-install configuration

- Make note of the IP attached to the VM (on boot, it will appear under "Address" as the `/24` value)
- In the UniFi console, locate the client with that IP and enable static IP (Settings -> Use Fixed IP Address)
- Before SSHing in, run `kubectl get nodes`. Ensure there's a new node listed with a name following the format `k3os-XXXXX`.
- SSH into the host with `ssh rancher@IP_ADDRESS`
- Run `sudo vi /var/lib/rancher/k3os/config.yaml`
- Add `hostname: INSTANCE_NAME`, where `INSTANCE_NAME` is the name of the VM, then save & quit.
- Run `sudo reboot`
- Once rebooted, run `kubectl get nodes` from your host. You should now see the new node in there as ready, and the old name showing as not ready. Copy the name and do `kubectl delete node OLD_NAME` to clean up the old node.
