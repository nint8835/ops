data_dir = "/opt/nomad"
datacenter = "{{ nomad_datacenter_name }}"

server {
    enabled = true
    bootstrap_expect = 3
}