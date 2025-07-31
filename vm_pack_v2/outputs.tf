output "nic_ids" {
  description = "The IDs of the network interfaces"
  value = {
    for vm_key, vm_config in var.virtual_machines :
    vm_key => [
      for index, nic in vm_config.network_interfaces :
      azurerm_network_interface.nic["${vm_key}-${index}"].id
    ]
  }
}

output "managed_disk_ids" {
  description = "The IDs of the managed disks"
  value = {
    for vm_key, vm_config in var.virtual_machines :
    vm_key => [
      for disk in(lookup(vm_config, "data_disks", []) != null ? lookup(vm_config, "data_disks", []) : []) :
      azurerm_managed_disk.disk["${vm_key}-${disk.name}"].id
    ]
  }
}


output "private_ip_addresses" {
  description = "The private IP addresses associated with the network interfaces"
  value = {
    for vm_key, vm_config in var.virtual_machines :
    vm_key => [
      for index, nic in vm_config.network_interfaces :
      azurerm_network_interface.nic["${vm_key}-${index}"].ip_configuration[0].private_ip_address
    ]
  }
}

output "admin_usernames" {
  description = "The admin usernames for each VM"
  value = {
    for vm_key, vm_config in var.virtual_machines :
    vm_key => vm_config.admin_username
  }
}
