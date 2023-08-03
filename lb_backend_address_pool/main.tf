resource "azurerm_lb_backend_address_pool" "bap" {
  loadbalancer_id    = var.loadbalancer_id
  name               = var.name
  virtual_network_id = var.virtual_network_id
}