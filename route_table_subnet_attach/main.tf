resource "azurerm_subnet_route_table_association" "rt_snet_attach" {
  subnet_id      = var.subnet_id
  route_table_id = var.route_table_id
}