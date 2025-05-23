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
resource "proxmox_virtual_environment_vm" "test1" {
  name      = "test8"
  vm_id     = 8888
  node_name = "st1pve3"
  depends_on = [
    proxmox_virtual_environment_network_linux_bridge.pve3_vmbr20
  ]
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
    bridge = "vmbr20"
  }
  initialization {
    datastore_id = "vms-shared"
    ip_config {
      ipv4 {
        address = "192.168.0.202/24"
        gateway = "192.168.0.1"
      }
    }
    dns {
      domain  = "si.impots.bj"
      servers = ["192.168.0.1"]
    }

    user_account {
      username = "root"
      keys     = var.root_ssh_keys
    }
  }
}

resource "proxmox_virtual_environment_download_file" "ubuntu_24_04_1" {
  content_type        = "vztmpl"
  datastore_id        = "toolstore"
  node_name           = "st1pve1"
  overwrite_unmanaged = true
  url                 = "http://download.proxmox.com/images/system/debian-12-standard_12.7-1_amd64.tar.zst"
}
resource "proxmox_virtual_environment_container" "test2" {
  vm_id     = 8881
  node_name = "st1pve2"
  depends_on = [
    proxmox_virtual_environment_network_linux_bridge.pve2_vmbr20
  ]
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
        address = "192.168.0.208/24"
        gateway = "192.168.0.1"
      }
    }
    user_account {
      password = "plopplop"
    }
  }
  network_interface {
    name   = "net0"
    bridge = "vmbr20"
  }
}