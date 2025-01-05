server {
  host = "pkg.nit.so"
}

go_module "switchboard" {
  path     = "switchboard"
  upstream = "https://github.com/nint8835/switchboard"

  display_name = "Switchboard"
  description  = "Utility library for Discordgo providing streamlined interaction support"

  link {
    text = "Source"
    url  = "https://github.com/nint8835/switchboard"
  }
}

go_module "goldmark-discord-mentions" {
  path     = "goldmark-discord-mentions"
  upstream = "https://github.com/nint8835/goldmark-discord-mentions"

  display_name = "goldmark-discord-mentions"
  description  = "Goldmark extension adding support for Discord mentions"

  link {
    text = "Source"
    url  = "https://github.com/nint8835/goldmark-discord-mentions"
  }
}
