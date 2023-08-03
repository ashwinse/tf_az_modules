resource "azurerm_lb_probe" "lbp" {
  loadbalancer_id     = var.loadbalancer_id
  name                = var.name
  port                = var.port
  protocol            = var.protocol
  probe_threshold     = var.probe_threshold
  interval_in_seconds = var.interval_in_seconds
  number_of_probes    = var.number_of_probes
}