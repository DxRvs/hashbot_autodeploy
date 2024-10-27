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

module "vm_min" {
  source = "./modules/vm/"           
  cpu_cores = "2"
  memgb = "4"
  platform_id = "standard-v1"
}

module "vm_cofig" {
  source = "./modules/config"           
  external_ip = module.vm_min.external_ip
  ssh_priv_key = "cloudkey.priv"
}

module "vm_ansible" {
  source = "./modules/ansible"     
  external_ip = module.vm_min.external_ip
  ssh_priv_key_file = abspath("cloudkey.priv")
  depends_on = [ module.vm_cofig ]
}