output "frontend_ip" {
  value = digitalocean_droplet.frontend.ipv4_address
  description = "The ip address of the frontend"
}


output "application_ip" {
  value = digitalocean_droplet.application.ipv4_address
  description = "The ip address of the application"
}