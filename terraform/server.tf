resource "digitalocean_tag" "application_tag" {
  name = "application"
}


resource "digitalocean_tag" "frontend_tag" {
  name = "frontend"
}

resource "digitalocean_tag" "id_tag" {
  name = "A00937032"
}


resource "digitalocean_droplet" "application_app" {
  image = var.image
  name = "application-A00937032"
  region = var.region
  tags = [digitalocean_tag.application_tag.id, digitalocean_tag.id_tag.id]
  size = "s-1vcpu-512mb-10gb"
  ssh_keys = [data.digitalocean_ssh_key.ssh_key.id]
  vpc_uuid = digitalocean_vpc.web_vpc.id

  lifecycle {
    create_before_destroy = true
  }
}


resource "digitalocean_droplet" "frontend_app" {
  image = var.image
  name = "frontend-A00937032"
  region = var.region
  tags = [digitalocean_tag.frontend_tag.id, digitalocean_tag.id_tag.id]
  size = "s-1vcpu-512mb-10gb"
  ssh_keys = [data.digitalocean_ssh_key.ssh_key.id]
  vpc_uuid = digitalocean_vpc.web_vpc.id

  lifecycle {
    create_before_destroy = true
  }
}


resource "digitalocean_project_resources" "project_attach" {
  project = data.digitalocean_project.lab_project.id
  resources = flatten([digitalocean_droplet.frontend_app.urn, digitalocean_droplet.application_app.urn])
}


resource "digitalocean_firewall" "frontend_fw" {   
    name = "frontend-firewall"                                 #
    droplet_ids = [digitalocean_droplet.frontend_app.id]

    inbound_rule {
        protocol         = "tcp"
        port_range       = "22"
        source_addresses = ["0.0.0.0/0", "::/0"]
  }

    inbound_rule {
        protocol = "tcp"
        port_range = "1-65535"
        source_addresses = ["0.0.0.0/0", "::/0"]
    }

    inbound_rule {
        protocol = "udp"
        port_range = "1-65535"
        source_addresses = ["0.0.0.0/0", "::/0"]
    }

    inbound_rule {
        protocol = "icmp"
        source_addresses = [digitalocean_vpc.web_vpc.ip_range]
    }
}


resource "digitalocean_firewall" "application_fw" {   
    name = "application-firewall"                                 #
    droplet_ids = [digitalocean_droplet.application_app.id]

    inbound_rule {
        protocol         = "tcp"
        port_range       = "22"
        source_addresses = ["0.0.0.0/0", "::/0"]
  }

    inbound_rule {
        protocol = "tcp"
        port_range = "1-65535"
        source_droplet_ids = [digitalocean_droplet.frontend_app.id] 
    }

    inbound_rule {
        protocol = "udp"
        port_range = "1-65535"
        source_droplet_ids = [digitalocean_droplet.frontend_app.id] 
    }

    inbound_rule {
        protocol = "icmp"
        source_addresses = [digitalocean_vpc.web_vpc.ip_range]
    }
}