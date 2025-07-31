data "azurerm_subnet" "subnet" {
  for_each             = var.subnet_info
  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_public_ip" "pip" {
  for_each            = var.pip_info
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_application_gateway" "appgtwy" {
  name                              = var.name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  tags                              = var.tags
  fips_enabled                      = var.fips_enabled
  zones                             = var.zones
  enable_http2                      = var.enable_http2
  force_firewall_policy_association = var.force_firewall_policy_association
  firewall_policy_id                = var.firewall_policy_id
  dynamic "authentication_certificate" {
    for_each = var.authentication_certificate != null ? [
      for s in var.authentication_certificate : {
        name = s.name
        data = s.data
    }] : []
    content {
      name = authentication_certificate.value.name
      data = authentication_certificate.value.data
    }
  }
  dynamic "redirect_configuration" {
    for_each = var.redirect_configuration != null ? [
      for s in var.redirect_configuration : {
        name                 = s.name
        redirect_type        = s.redirect_type
        target_listener_name = s.target_listener_name
        target_url           = s.target_url
        include_path         = s.include_path
        include_query_string = s.include_query_string
    }] : []
    content {
      name                 = redirect_configuration.value.name
      redirect_type        = redirect_configuration.value.redirect_type
      target_listener_name = redirect_configuration.value.target_url == null ? redirect_configuration.value.target_listener_name : null
      target_url           = redirect_configuration.value.target_listener_name == null ? redirect_configuration.value.target_url : null
      include_path         = redirect_configuration.value.include_path
      include_query_string = redirect_configuration.value.include_query_string
    }
  }
  dynamic "autoscale_configuration" {
    for_each = var.autoscale_configuration != null ? [
      for s in var.autoscale_configuration : {
        min_capacity = s.min_capacity
        max_capacity = s.max_capacity
    }] : []
    content {
      min_capacity = autoscale_configuration.value.min_capacity
      max_capacity = autoscale_configuration.value.max_capacity
    }
  }
  dynamic "custom_error_configuration" {
    for_each = var.custom_error_configuration != null ? [
      for s in var.custom_error_configuration : {
        status_code           = s.status_code
        custom_error_page_url = s.custom_error_page_url
    }] : []
    content {
      status_code           = custom_error_configuration.value.status_code
      custom_error_page_url = custom_error_configuration.value.custom_error_page_url
    }
  }

  dynamic "waf_configuration" {
    for_each = var.is_waf_configuration_enabled != null ? [1] : []
    content {
      enabled                  = var.is_waf_configuration_enabled
      firewall_mode            = var.firewall_mode
      rule_set_type            = var.rule_set_type
      rule_set_version         = var.rule_set_version
      file_upload_limit_mb     = var.file_upload_limit_mb
      request_body_check       = var.request_body_check
      max_request_body_size_kb = var.max_request_body_size_kb
    }
  }
  dynamic "ssl_certificate" {
    for_each = var.ssl_certificate != null ? [
      for s in var.ssl_certificate : {
        name                = s.name
        data                = s.data
        password            = s.password
        key_vault_secret_id = s.key_vault_secret_id

    }] : []
    content {
      name                = ssl_certificate.value.name
      data                = ssl_certificate.value.data
      password            = ssl_certificate.value.password
      key_vault_secret_id = ssl_certificate.value.data == null ? ssl_certificate.value.key_vault_secret_id : null
    }
  }

  dynamic "global" {
    for_each = var.is_global == true ? [1] : []
    content {
      request_buffering_enabled  = var.request_buffering_enabled
      response_buffering_enabled = var.response_buffering_enabled
    }
  }
  dynamic "identity" {
    for_each = var.is_identity == true ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_ids
    }
  }


  sku {
    name     = var.sku_name #"Standard_Small"
    tier     = var.tier     #"Standard"
    capacity = var.capacity
  }

  dynamic "gateway_ip_configuration" {
    for_each = var.gateway_ip_configuration != null ? [
      for s in var.gateway_ip_configuration : {
        name      = s.name
        subnet_id = s.subnet_id
    }] : []
    content {
      name      = gateway_ip_configuration.value.name
      subnet_id = try(lookup(data.azurerm_subnet.subnet, gateway_ip_configuration.value.subnet_id).id, null)
    }
  }

  dynamic "frontend_port" {
    for_each = var.frontend_port != null ? [
      for s in var.frontend_port : {
        name = s.name
        port = s.port
    }] : []
    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configuration != null ? [
      for s in var.frontend_ip_configuration : {
        name                            = s.name
        subnet_id                       = s.subnet_id
        private_ip_address              = s.private_ip_address
        public_ip_address_id            = s.public_ip_address_id
        private_ip_address_allocation   = s.private_ip_address_allocation
        private_link_configuration_name = s.private_link_configuration_name

    }] : []
    content {
      name                            = frontend_ip_configuration.value.name
      subnet_id                       = try(lookup(data.azurerm_subnet.subnet, frontend_ip_configuration.value.subnet_id, ).id, null)
      private_ip_address              = try(frontend_ip_configuration.value.private_ip_address, null)
      public_ip_address_id            = try(lookup(data.azurerm_public_ip.pip, frontend_ip_configuration.value.public_ip_address_id, ).id, null)
      private_ip_address_allocation   = try(frontend_ip_configuration.value.private_ip_address_allocation, null)
      private_link_configuration_name = try(frontend_ip_configuration.value.private_link_configuration_name, null)
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pool != null ? [
      for s in var.backend_address_pool : {
        name         = s.name
        fqdn         = s.fqdn
        ip_addresses = s.ip_addresses
    }] : []
    content {
      name         = backend_address_pool.value.name
      ip_addresses = try(backend_address_pool.value.ip_addresses, [null])
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings != null ? [
      for s in var.backend_http_settings : {
        name                                = s.name
        cookie_based_affinity               = s.cookie_based_affinity
        path                                = s.path
        port                                = s.port
        protocol                            = s.protocol
        request_timeout                     = s.request_timeout
        affinity_cookie_name                = s.affinity_cookie_name
        probe_name                          = s.probe_name
        host_name                           = s.host_name
        pick_host_name_from_backend_address = s.pick_host_name_from_backend_address
        trusted_root_certificate_names      = s.trusted_root_certificate_names
    }] : []
    content {
      name                                = backend_http_settings.value.name
      cookie_based_affinity               = backend_http_settings.value.cookie_based_affinity
      path                                = try(backend_http_settings.value.path, null)
      port                                = backend_http_settings.value.port
      protocol                            = backend_http_settings.value.protocol
      request_timeout                     = backend_http_settings.value.request_timeout
      affinity_cookie_name                = try(backend_http_settings.value.affinity_cookie_name, null)
      probe_name                          = try(backend_http_settings.value.probe_name, null)
      host_name                           = try(backend_http_settings.value.host_name, null)
      pick_host_name_from_backend_address = try(backend_http_settings.value.pick_host_name_from_backend_address, null)
      trusted_root_certificate_names      = try(backend_http_settings.value.trusted_root_certificate_names, [null])
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listener != null ? [
      for s in var.http_listener : {
        name                           = s.name
        frontend_ip_configuration_name = s.frontend_ip_configuration_name
        frontend_port_name             = s.frontend_port_name
        host_name                      = s.host_name
        host_names                     = s.host_names
        protocol                       = s.protocol
        require_sni                    = s.require_sni
        ssl_certificate_name           = s.ssl_certificate_name
        firewall_policy_id             = s.firewall_policy_id
        ssl_profile_name               = s.ssl_profile_name
    }] : []
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      host_name                      = try(http_listener.value.host_name, null)
      host_names                     = try(http_listener.value.host_names, null)
      protocol                       = http_listener.value.protocol
      require_sni                    = try(http_listener.value.require_sni, false)
      ssl_certificate_name           = try(http_listener.value.ssl_certificate_name, null)
      firewall_policy_id             = try(http_listener.value.firewall_policy_id, null)
      ssl_profile_name               = try(http_listener.value.ssl_profile_name, null)
    }
  }




  dynamic "request_routing_rule" {
    for_each = var.request_routing_rule != null ? [
      for s in var.request_routing_rule : {
        name                        = s.name
        rule_type                   = s.rule_type
        http_listener_name          = s.http_listener_name
        backend_address_pool_name   = s.backend_address_pool_name
        backend_http_settings_name  = s.backend_http_settings_name
        redirect_configuration_name = s.redirect_configuration_name
        rewrite_rule_set_name       = s.rewrite_rule_set_name
        url_path_map_name           = s.url_path_map_name
        priority                    = s.priority

    }] : []
    content {
      name                        = request_routing_rule.value.name
      rule_type                   = request_routing_rule.value.rule_type
      http_listener_name          = request_routing_rule.value.http_listener_name
      backend_address_pool_name   = try(request_routing_rule.value.backend_address_pool_name, null)
      backend_http_settings_name  = try(request_routing_rule.value.backend_http_settings_name, null)
      redirect_configuration_name = request_routing_rule.value.redirect_configuration_name
      rewrite_rule_set_name       = try(request_routing_rule.value.rewrite_rule_set_name, null)
      url_path_map_name           = try(request_routing_rule.value.url_path_map_name, null)
      priority                    = try(request_routing_rule.value.priority, null)

    }
  }
}