resource "azurerm_virtual_network_gateway" "vngw" {
  name                             = var.configurations.name
  resource_group_name              = try(var.configurations.resource_group_name, var.resource_group_name)
  location                         = try(var.configurations.location, var.location)
  type                             = var.configurations.type
  vpn_type                         = var.configurations.vpn_type
  active_active                    = try(var.configurations.active_active, null)
  enable_bgp                       = try(var.configurations.enable_bgp, null)
  sku                              = var.configurations.sku
  default_local_network_gateway_id = try(var.configurations.default_local_network_gateway_id, null)
  remote_vnet_traffic_enabled      = try(var.configurations.remote_vnet_traffic_enabled, null)
  edge_zone                        = try(var.configurations.edge_zone, null)
  generation                       = try(var.configurations.generation, null)
  private_ip_address_enabled       = try(var.configurations.private_ip_address_enabled, null)
  tags                             = try(var.configurations.tags, var.tags)
  dynamic "ip_configuration" {
    for_each = try(var.configurations.ip_configurations, null) != null ? var.configurations.ip_configurations : {}
    content {
      name                          = try(ip_configuration.value.ipconfig_name, null)
      public_ip_address_id          = can(ip_configuration.value.public_ip_address_id) || can(ip_configuration.value.public_ip_address_key) == false ? try(ip_configuration.value.public_ip_address_id, null) : var.public_ip_addresses[ip_configuration.value.public_ip_address_key].id
      private_ip_address_allocation = try(ip_configuration.value.private_ip_address_allocation, null)
      subnet_id                     = can(ip_configuration.value.subnet_id) || can(ip_configuration.value.subnet_key) == false ? try(ip_configuration.value.subnet_id, null) : var.subnets[ip_configuration.value.subnet_key].id
    }
  }

  dynamic "custom_route" {
    for_each = try(var.configurations.custom_route, null) != null ? var.configurations.custom_route : {}
    content {
      address_prefixes = try(var.configurations.custom_route.address_prefixes, [])
    }
  }

  dynamic "vpn_client_configuration" {
    for_each = try(var.configurations.vpn_client_configuration, null) != null ? [var.configurations.vpn_client_configuration[keys(var.configurations.vpn_client_configuration)[0]]] : []
    content {
      address_space  = vpn_client_configuration.value.address_space
      aad_tenant     = try(vpn_client_configuration.value.aad_tenant, null)
      aad_audience   = try(vpn_client_configuration.value.aad_audience, null)
      aad_issuer     = try(vpn_client_configuration.value.aad_issuer, null)
      vpn_auth_types = try(vpn_client_configuration.value.vpn_auth_types, null)
      dynamic "ipsec_policy" {
        for_each = try(vpn_client_configuration.value.ipsec_policy, null) != null ? vpn_client_configuration.value.ipsec_policy : []
        content {
          dh_group                  = vpn_client_configuration.value.ipsec_policy.dh_group
          ike_encryption            = vpn_client_configuration.value.ipsec_policy.ike_encryption
          ike_integrity             = vpn_client_configuration.value.ipsec_policy.ike_integrity
          ipsec_encryption          = vpn_client_configuration.value.ipsec_policy.ipsec_encryption
          ipsec_integrity           = vpn_client_configuration.value.ipsec_policy.ipsec_integrity
          pfs_group                 = vpn_client_configuration.value.ipsec_policy.pfs_group
          sa_lifetime_in_seconds    = vpn_client_configuration.value.ipsec_policy.sa_lifetime_in_seconds
          sa_data_size_in_kilobytes = vpn_client_configuration.value.ipsec_policy.sa_data_size_in_kilobytes
        }
      }
      dynamic "root_certificate" {
        for_each = can(vpn_client_configuration.value.root_certificate) ? [1] : []
        content {
          name             = vpn_client_configuration.value.root_certificate.name
          public_cert_data = vpn_client_configuration.value.root_certificate.public_cert_data
        }
      }
      # dynamic "revoked_certificate" {
      #     for_each = try(vpn_client_configuration.value.revoked_certificate, {})
      #     content {
      #         name       = revoked_certificate.value.name
      #         thumbprint = revoked_certificate.value.thumbprint
      #     }
      # }
    }
  }

  dynamic "bgp_settings" {
    for_each = try(var.configurations.bgp_settings, null) != null ? var.configurations.bgp_settings : {}
    content {
      asn = try(bgp_settings.value.asn, null)
      peering_addresses {
        ip_configuration_name = try(bgp_settings.value.peering_addresses.value.ip_configuration_name, null)
        apipa_addresses       = try(bgp_settings.value.peering_addresses.value.apipa_addresses, [])
      }
    }
  }
}