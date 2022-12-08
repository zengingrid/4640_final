output "frontend_ip" {
  value = digitalocean_droplet.frontend_app.ipv4_address
  description = "The ip address of the frontend"
}


output "application_ip" {
  value = digitalocean_droplet.application_app.ipv4_address
  description = "The ip address of the application"
}