terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

# Criar a rede para os containers do MongoDB
resource "docker_network" "mongo_network" {
  name = "mongo_network"
}

# Criar container do nó primário
resource "docker_container" "mongo_primary" {
  name  = "mongo_primary"
  image = "mongo:7.0"
  restart = "always"

  networks_advanced {
    name = docker_network.mongo_network.name
  }

  ports {
    internal = 27017
    external = 27017
  }

  volumes {
    host_path      = "${abspath(path.module)}/mongo-keyfile"
    container_path = "/data/keyfile"
  }

  volumes {
    host_path      = "${abspath(path.module)}/init-replica.js"
    container_path = "/docker-entrypoint-initdb.d/init-replica.js"
  }

  env = [
    "MONGO_INITDB_ROOT_USERNAME=admin",
    "MONGO_INITDB_ROOT_PASSWORD=adminpass",
    "MONGO_REPLICA_SET_NAME=rs0"
  ]

  command = [
    "mongod",
    "--replSet", "rs0",
    "--keyFile", "/data/keyfile",
    "--bind_ip_all"
  ]

  provisioner "local-exec" {
    command = "sleep 10 && docker exec mongo_primary mongosh /docker-entrypoint-initdb.d/init-replica.js"
  }
}

# Criar container do primeiro nó secundário
resource "docker_container" "mongo_secondary_1" {
  name  = "mongo_secondary_1"
  image = "mongo:7.0"
  restart = "always"

  networks_advanced {
    name = docker_network.mongo_network.name
  }

  volumes {
    host_path      = "${abspath(path.module)}/mongo-keyfile"
    container_path = "/data/keyfile"
  }

  env = [
    "MONGO_INITDB_ROOT_USERNAME=admin",
    "MONGO_INITDB_ROOT_PASSWORD=adminpass",
    "MONGO_REPLICA_SET_NAME=rs0"
  ]

  command = [
    "mongod",
    "--replSet", "rs0",
    "--keyFile", "/data/keyfile",
    "--bind_ip_all"
  ]
}

# Criar container do segundo nó secundário
resource "docker_container" "mongo_secondary_2" {
  name  = "mongo_secondary_2"
  image = "mongo:7.0"
  restart = "always"

  networks_advanced {
    name = docker_network.mongo_network.name
  }

  volumes {
    host_path      = "${abspath(path.module)}/mongo-keyfile"
    container_path = "/data/keyfile"
  }

  env = [
    "MONGO_INITDB_ROOT_USERNAME=admin",
    "MONGO_INITDB_ROOT_PASSWORD=adminpass",
    "MONGO_REPLICA_SET_NAME=rs0"
  ]

  command = [
    "mongod",
    "--replSet", "rs0",
    "--keyFile", "/data/keyfile",
    "--bind_ip_all"
  ]
}