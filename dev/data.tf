data "digitalocean_ssh_key" "ssh_key" {
  name = "assign_key"
}

data "digitalocean_project" "lab_project" {
  name = "4640"
}