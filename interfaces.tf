resource "proxmox_virtual_environment_network_linux_vlan" "pve1_vlan20" {
  node_name = "st1pve1"
  name      = "bond0.20"
  comment   = "VLAN 20"
}
resource "proxmox_virtual_environment_network_linux_bridge" "pve1_vmbr20" {
  depends_on = [
    proxmox_virtual_environment_network_linux_vlan.pve1_vlan20
  ]
  node_name = "st1pve1"
  name      = "vmbr20"
  comment   = "Réseau production"
  ports = [
    "bond0.20"
  ]
}
resource "proxmox_virtual_environment_network_linux_vlan" "pve2_vlan20" {
  node_name = "st1pve2"
  name      = "bond0.20"
  comment   = "VLAN 20"
}
resource "proxmox_virtual_environment_network_linux_bridge" "pve2_vmbr20" {
  depends_on = [
    proxmox_virtual_environment_network_linux_vlan.pve2_vlan20
  ]
  node_name = "st1pve2"
  name      = "vmbr20"
  comment   = "Réseau production"
  ports = [
    "bond0.20"
  ]
}
resource "proxmox_virtual_environment_network_linux_vlan" "pve3_vlan20" {
  node_name = "st1pve3"
  name      = "bond0.20"
  comment   = "VLAN 20"
}
resource "proxmox_virtual_environment_network_linux_bridge" "pve3_vmbr20" {
  depends_on = [
    proxmox_virtual_environment_network_linux_vlan.pve3_vlan20
  ]
  node_name = "st1pve3"
  name      = "vmbr20"
  comment   = "Réseau production"
  ports = [
    "bond0.20"
  ]
}