# rileyflynn.me on the Hashistack

## Prereqs

- [Docker](https://docs.docker.com/engine/install/)
- [Nomad](https://learn.hashicorp.com/tutorials/nomad/get-started-install?in=nomad/get-started)
- [Consul](https://learn.hashicorp.com/tutorials/consul/get-started-install?in=consul/getting-started)

## Usage

- In one terminal window, start a dev instance of Consul
  - `consul agent -dev`
- In another terminal window, start a dev instance of Nomad
  - `nomad agent -dev`
- In another terminal window, start the Nomad jobs
  - `nomad run traefik.nomad`
  - `nomad run rileyflynn.me.nomad`
