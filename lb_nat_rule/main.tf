resource "azurerm_lb_nat_rule" "lbnr" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = var.loadbalancer_id
  name                           = var.name
  protocol                       = var.protocol
  frontend_port                  = var.frontend_port
  backend_port                   = var.backend_port
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  frontend_port_start            = var.frontend_port_start
  frontend_port_end              = var.frontend_port_end
  backend_address_pool_id        = var.backend_address_pool_id
  idle_timeout_in_minutes        = var.idle_timeout_in_minutes
  enable_floating_ip             = var.enable_floating_ip
  enable_tcp_reset               = var.enable_tcp_reset
}

# for VMs