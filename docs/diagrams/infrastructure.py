# This file uses a WIP feature of Diagrams, that allows setting icons on clusters.
# Until it's merged, setting up is a bit tricky. Before continuing, ensure you have poetry installed.
# 1. git clone https://github.com/bkmeneguello/diagrams.git
# 2. git checkout node-as-cluster
# 3. poetry build
# 4. From the venv / python install used to run this code, pip install the output wheel file

from functools import partial
from typing import Callable, List, Tuple, Type

from custom import VPC, Debian, Droplet, Tailscale, Unbound
from diagrams import Cluster, Diagram, Edge, Node
from diagrams.generic.storage import Storage
from diagrams.generic.virtualization import XEN
from diagrams.onprem.compute import Nomad, Server
from diagrams.onprem.monitoring import Prometheus
from diagrams.onprem.network import Consul, Internet, Traefik
from diagrams.onprem.security import Vault


def cluster_server(
    tailscale_agent: Tailscale,
):
    nomad = Nomad("Nomad server")
    vault = Vault("Vault server")
    consul = Consul("Consul server")
    unbound = Unbound("Unbound server")
    node_exporter = Prometheus("node_exporter")

    unbound >> consul

    [nomad, vault, consul, unbound, node_exporter] << Edge() >> tailscale_agent


def cluster_agent(
    tailscale_agent: Tailscale,
) -> Tuple[Nomad, Consul]:
    nomad = Nomad("Nomad agent")
    consul = Consul("Consul agent")
    node_exporter = Prometheus("node_exporter")

    [nomad, consul, node_exporter] << Edge() >> tailscale_agent


with Diagram("Infrastructure", show=False, direction="TB", curvestyle="curved"):
    tailscale_network = Tailscale("Tailscale network")
    internet = Internet()

    with XEN("XCP-ng Pool"):
        with Server("Hera"):
            for server_name in ["Atropos", "Clotho", "Lachesis"]:
                with Debian(server_name):
                    tailscale_agent = Tailscale("Tailscale agent")
                    tailscale_agent << Edge() >> tailscale_network
                    cluster_server(tailscale_agent)

            with Debian("Auge"):
                tailscale_agent = Tailscale("Tailscale agent")
                tailscale_agent << Edge() >> tailscale_network
                cluster_agent(tailscale_agent)

                Prometheus("Prometheus") << Edge() >> tailscale_agent
                Traefik("Traefik (internal)") << Edge() >> tailscale_agent

            with Debian("Charon"):
                tailscale_agent = Tailscale("Tailscale agent")
                tailscale_agent << Edge() >> tailscale_network

            Storage("Mnemosyne")

            with Debian("Xen Orchestra"):
                tailscale_agent = Tailscale("Tailscale agent")
                tailscale_agent << Edge() >> tailscale_network

        with Server("Zeus"):
            pass

    with VPC("DigitalOcean VPC"):
        with Droplet("Cerberus"):
            tailscale_agent = Tailscale("Tailscale agent")
            tailscale_agent << Edge() >> tailscale_network
            cluster_agent(tailscale_agent)

            traefik = Traefik("Traefik (external)")
            traefik << Edge() >> [tailscale_agent, internet]
