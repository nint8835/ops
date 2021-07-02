service {
  name = "consul-ui"
  port = 8500

  tags = [
    "traefik_internal.enable=true",
    "traefik_internal.http.routers.http.rule=Host(`consul.internal.bootleg.technology`)",
    "embassy.enable=true",
    "embassy.title=Consul",
    "embassy.url=http://consul.internal.bootleg.technology",
    "embassy.icon_url=https://simpleicons.org/icons/consul.svg",
    "embassy.description=Service discovery & key/value store",
    "embassy.group=Management"
  ] 
}
