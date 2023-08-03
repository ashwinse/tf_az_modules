resource "azurerm_lb_rule" "lbr" {
  loadbalancer_id                = var.loadbalancer_id
  name                           = var.name
  protocol                       = var.protocol
  frontend_port                  = var.frontend_port
  backend_port                   = var.backend_port
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  probe_id                       = var.probe_id
  enable_floating_ip             = var.enable_floating_ip
  enable_tcp_reset               = var.enable_tcp_reset
  disable_outbound_snat          = var.disable_outbound_snat
  load_distribution              = var.load_distribution
  idle_timeout_in_minutes        = var.idle_timeout_in_minutes
  backend_address_pool_ids       = var.backend_address_pool_ids
}