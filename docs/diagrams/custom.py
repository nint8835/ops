import os

from diagrams import Node


class _CustomIcon(Node):
    provider = "custom"
    _icon_dir = os.path.join(os.getcwd(), "icons")


class Debian(_CustomIcon):
    _icon = "debian.svg"


class Droplet(_CustomIcon):
    _icon = "droplet.png"


class VPC(_CustomIcon):
    _icon = "vpc.png"


class Unbound(_CustomIcon):
    _icon = "unbound.svg"


class Tailscale(_CustomIcon):
    _icon = "tailscale.png"
