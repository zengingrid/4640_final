# The API token
variable "do_token" {}

# The region with default sfo3
variable "region" {
  type = string
  default = "sfo3"
}

# The droplet count with default 2
variable "droplet_count" {
  type = number
  default = 2
}

