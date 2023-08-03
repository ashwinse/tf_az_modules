resource "azurerm_sql_server" "sql_server" {
  name                         = var.name # NOTE: needs to be globally unique
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.sql_version # "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  tags                         = var.tags
}
