resource "digitalocean_vpc" "web_vpc" {
  name = "web"
  region = var.region
  ip_range = var.network_range
}

