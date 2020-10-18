service {
  name = "nomad-ui"
  port = 4646

  tags = [
    "traefik_internal.enable=true",
    "traefik_internal.http.routers.nomad.rule=Host(`nomad.internal.bootleg.technology`)",
  ] 
}
