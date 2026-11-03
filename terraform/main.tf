# Configure the Docker provider
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Pull the nginx image
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

# Create a container
resource "docker_container" "nginx_server" {
  image = docker_image.nginx.image_id
  name  = "my-nginx-server"

  ports {
    internal = 80
    external = 8081
  }
}