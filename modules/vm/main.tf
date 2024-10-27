terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
  required_version = ">= 0.13"
}
provider "yandex" {
  zone = "ru-central1-a"
}
resource "yandex_compute_disk" "boot-disk-1" {
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "20"
  image_id = "fd83j4siasgfq4pi1qif"
}

resource "yandex_compute_instance" "vm-1" {
  name = "bruteforce01"
  allow_stopping_for_update = true
  platform_id = var.platform_id
  resources {
    cores  = var.cpu_cores
    memory = var.memgb
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-1.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
    nat_ip_address = yandex_vpc_address.addr.external_ipv4_address[0].address
  }
  metadata = {
    user-data = "${file("meta.txt")}"
  }
}
resource "yandex_vpc_address" "addr" {
  name = "bf_external"
  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}
resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
