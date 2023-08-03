resource "azurerm_lb" "lb" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  frontend_ip_configuration {
    name                          = var.frontend_ip_configuration_name
    public_ip_address_id          = var.public_ip_address_id
    private_ip_address            = var.private_ip_address
    private_ip_address_allocation = var.private_ip_address_allocation
    subnet_id                     = var.subnet_id
  }
  tags     = var.tags
  sku_tier = var.sku_tier
}



