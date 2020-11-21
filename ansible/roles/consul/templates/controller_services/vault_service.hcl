service {
  name = "vault-ui"
  port = 8200

  tags = [
    "traefik_internal.enable=true",
    "traefik_internal.http.routers.vault.rule=Host(`vault.internal.bootleg.technology`)",
  ] 
}
