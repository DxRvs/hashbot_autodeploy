terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
  required_version = ">= 0.13"
}

resource "local_file" "private_key" {
  content  = "[ycloud]\nbforce ansible_host=${var.external_ip} ansible_user=user ansible_ssh_private_key_file=${var.ssh_priv_key_file}"
  filename = "${path.module}/hosts"
}

provider "null" {}

resource "null_resource" "example" {
  depends_on = [ local_file.private_key ]
  provisioner "local-exec" {
    command = "ansible-playbook -i ${path.module}/hosts ${path.module}/main.yaml"
  }
}
