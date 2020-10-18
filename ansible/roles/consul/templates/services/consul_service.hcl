service {
  name = "consul-ui"
  port = 8500

  tags = [
    "traefik_internal.enable=true",
    "traefik_internal.http.routers.http.rule=Host(`consul.internal.bootleg.technology`)",
  ] 
}
