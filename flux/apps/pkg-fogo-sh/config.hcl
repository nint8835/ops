server {
  host = "pkg.fogo.sh"
}

go_module "almanac" {
  path = "almanac"
  upstream = "https://github.com/fogo-sh/almanac"

  display_name = "Almanac"

  link {
    text = "Source"
    url = "https://github.com/fogo-sh/almanac"
  }
}
