service {
  name = "nomad-ui"
  port = 4646

  tags = [
    "traefik_internal.enable=true",
    "traefik_internal.http.routers.nomad.rule=Host(`nomad.internal.bootleg.technology`)",
    "embassy.enable=true",
    "embassy.title=Nomad",
    "embassy.url=http://nomad.internal.bootleg.technology",
    "embassy.description=Cluster job scheduler",
    "embassy.group=Management"
  ] 
}
