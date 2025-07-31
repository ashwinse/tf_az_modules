resource "azurerm_virtual_network_gateway_connection" "vpn_gw_conn" {
  name                       = var.configurations.name
  resource_group_name        = try(var.configurations.resource_group_name, var.resource_group_name)
  location                   = try(var.configurations.location, var.location)
  type                       = var.configurations.type
  virtual_network_gateway_id = can(var.configurations.virtual_network_gateway_id) || can(var.configurations.virtual_network_gateway_key) == false ? try(var.configurations.virtual_network_gateway_id, null) : var.virtual_network_gateways[var.configurations.virtual_network_gateway_key].id

  # The following arguments are applicable only if the type is ExpressRoute
  express_route_circuit_id = try(can(var.configurations.express_route_circuit_id) || can(var.configurations.express_route_circuit_key) == false ? try(var.configurations.express_route_circuit_id, null) : var.express_route_circuits[var.configurations.express_route_circuit_key].id, null)
  authorization_key        = try(var.configurations.authorization_key, null)

  # The following arguments are applicable only if the type is IPsec (VPN)
  connection_protocol                = try(var.configurations.connection_method, null)
  dpd_timeout_seconds                = try(var.configurations.dpd_timeout_seconds, null)
  shared_key                         = try(var.configurations.shared_key, null)
  enable_bgp                         = try(var.configurations.enable_bgp, null)
  local_network_gateway_id           = try(can(var.configurations.local_network_gateway_id) || can(var.configurations.local_network_gateway_key) == false ? try(var.configurations.local_network_gateway_id, null) : var.local_network_gateways[var.configurations.local_network_gateway_key].id, null)
  routing_weight                     = try(var.configurations.routing_weight, null)
  use_policy_based_traffic_selectors = try(var.configurations.use_policy_based_traffic_selectors, false)

  dynamic "ipsec_policy" {
    for_each = try(var.configurations.ipsec_policy, null) != null ? var.configurations.ipsec_policy : {}
    content {
      dh_group         = ipsec_policy.value.dh_group
      ike_encryption   = ipsec_policy.value.ike_encryption
      ike_integrity    = ipsec_policy.value.ike_integrity
      ipsec_encryption = ipsec_policy.value.ipsec_encryption
      ipsec_integrity  = ipsec_policy.value.ipsec_integrity
      pfs_group        = ipsec_policy.value.pfs_group
      sa_datasize      = try(ipsec_policy.value.sa_datasize, null)
      sa_lifetime      = try(ipsec_policy.value.sa_lifetime, null)
    }
  }
  tags = try(var.configurations.tags, var.tags)
}