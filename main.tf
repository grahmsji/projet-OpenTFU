terraform {
  required_version = "1.9.1"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.77.0"
    }
  }
}
provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = true
  ssh {
    username = "root"
    agent    = true
  }

}
resource "proxmox_virtual_environment_download_file" "ubuntu_24_20250430" {
  content_type        = "iso"
  datastore_id        = "toolstore"
  node_name           = "st1pve1"
  overwrite_unmanaged = true
  url                 = "http://cloud-images.ubuntu.com/noble/20250430/noble-server-cloudimg-amd64.img"
}
resource "proxmox_virtual_environment_vm" "test4" {
  name       = "test4"
  vm_id      = 4444
  node_name  = "st1pve1"
  tags       = ["tofu", "ubuntu"]
  on_boot    = true
  protection = false
  migrate    = true
  cpu {
    cores = 4
    type  = "x86-64-v2-AES"
  }
  memory {
    dedicated = 4096
    floating  = 4096
  }
  disk {
    datastore_id = "vms-shared"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_24_20250430.id
    interface    = "virtio0"
    size         = 50
    iothread     = true
  }
  network_device {
    bridge = "vmbr0"
  }
  initialization {
    datastore_id = "vms-shared"
    ip_config {
      ipv4 {
        address = "192.168.0.201/24"
        gateway = "192.168.0.1"
      }
    }
    dns {
      domain  = "si.impots.bj"
      servers = ["192.168.0.1"]
    }
    user_account {
      username = "ubuntu"
      password = "plopplop"
    }
  }
}
resource "proxmox_virtual_environment_download_file" "ubuntu_24_04_1" {
  content_type        = "vztmpl"
  datastore_id        = "toolstore"
  node_name           = "st1pve1"
  overwrite_unmanaged = true
  url                 = "http://download.proxmox.com/images/system/ubuntu-24.04-standard_24.04-1_amd64.tar.zst"
}
resource "proxmox_virtual_environment_container" "test2" {
  vm_id         = 2223
  node_name     = "pve3"
  tags          = ["tofu", "ubuntu"]
  start_on_boot = true
  protection    = false
  operating_system {
    template_file_id = proxmox_virtual_environment_download_file.ubuntu_24_04_1.id
    type             = "ubuntu"
  }
  memory {
    dedicated = 1024
  }
  disk {
    datastore_id = "vms-shared"
    size         = 10
  }
  initialization {
    hostname = "test2"
    ip_config {
      ipv4 {
        address = "192.168.0.202/24"
        gateway = "192.168.0.1"
      }
    }
    user_account {
      password = "plopplop"
    }
  }
  network_interface {
    name = "vmbr0"
  }
}