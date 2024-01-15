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
