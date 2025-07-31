
resource "azurerm_virtual_desktop_workspace" "wvdws" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

}