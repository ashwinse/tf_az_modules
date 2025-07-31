data "azurerm_public_ip" "pip" {
  for_each            = var.ip_config
  name                = each.value.public_ip_name
  resource_group_name = var.resource_group_name
}