output "resource_group_ids" {
  value = try(data.azurerm_resource_group.rg[0].id, null)
}
output "availability_set_ids" {
  value = try(data.azurerm_availability_set.avset[0].id, null)
}
output "managed_disk_ids" {
  value = try(data.azurerm_managed_disk.md[0].id, null)
}


output "public_ip_address_ids" {
  value = try(data.azurerm_public_ip.pip[0].id, null)
}

output "virtual_network_ids" {
  value = try(data.azurerm_virtual_network.vnet[0].id, null)
}

output "subnet_ids" {
  value = try(data.azurerm_subnet.subnet[0].id, null)
}


output "network_security_group_ids" {
  value = try(data.azurerm_network_security_group.nsg[0].id, null)
}


output "route_table_ids" {
  value = try(data.azurerm_route_table.rt[0].id, null)
}

output "network_interface_ids" {
  value = try(data.azurerm_network_interface.nic[0].id, null)
}