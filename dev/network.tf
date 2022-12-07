resource "digitalocean_vpc" "web_vpc" {
  name = "web"
  region = var.region
  ip_range = "10.46.40.0/24"
}
