output "id" {
  value = azurerm_windows_virtual_machine.vmw.id
}

output "public_ip_address" {
  value = azurerm_windows_virtual_machine.vmw.public_ip_address
}

output "private_ip_address" {
  value = azurerm_windows_virtual_machine.vmw.private_ip_address
}


output "public_ip_addresses" {
  value = azurerm_windows_virtual_machine.vmw.public_ip_addresses
}

output "private_ip_addresses" {
  value = azurerm_windows_virtual_machine.vmw.private_ip_addresses
}

output "admin_username" {
  value = azurerm_windows_virtual_machine.vmw.admin_username
}

output "admin_password" {
  sensitive = true
  value     = azurerm_windows_virtual_machine.vmw.admin_password
}