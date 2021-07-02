service {
  name = "vault-ui"
  port = 8200

  tags = [
    "traefik_internal.enable=true",
    "traefik_internal.http.routers.vault.rule=Host(`vault.internal.bootleg.technology`)",
    "embassy.enable=true",
    "embassy.title=Vault",
    "embassy.url=http://vault.internal.bootleg.technology",
    "embassy.icon_url=https://simpleicons.org/icons/vault.svg",
    "embassy.description=Secrets management",
    "embassy.group=Security"
  ] 
}
