resource "azurerm_lb_nat_pool" "lbnp" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = var.loadbalancer_id
  name                           = var.name
  protocol                       = var.protocol
  frontend_port_start            = var.frontend_port_start
  frontend_port_end              = var.frontend_port_end
  backend_port                   = var.backend_port
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  idle_timeout_in_minutes        = var.idle_timeout_in_minutes
  floating_ip_enabled            = var.floating_ip_enabled
  tcp_reset_enabled              = var.tcp_reset_enabled
}


# For VM scale sets