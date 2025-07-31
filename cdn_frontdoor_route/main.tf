resource "azurerm_cdn_frontdoor_route" "fdroute" {
  name                          = var.name
  cdn_frontdoor_endpoint_id     = var.cdn_frontdoor_endpoint_id
  cdn_frontdoor_origin_group_id = var.cdn_frontdoor_origin_group_id
  cdn_frontdoor_origin_ids      = var.cdn_frontdoor_origin_ids
  cdn_frontdoor_rule_set_ids    = var.cdn_frontdoor_rule_set_ids
  enabled                       = var.is_route_enabled

  forwarding_protocol    = var.forwarding_protocol
  https_redirect_enabled = var.https_redirect_enabled
  patterns_to_match      = var.patterns_to_match
  supported_protocols    = var.supported_protocols

  cdn_frontdoor_custom_domain_ids = var.cdn_frontdoor_custom_domain_ids
  link_to_default_domain          = var.link_to_default_domain

  dynamic "cache" {
    for_each = var.cache != null ? var.cache : {}
    content {
      query_string_caching_behavior = try(cache.value.query_string_caching_behavior, null)
      query_strings                 = try(cache.value.query_strings, null)
      compression_enabled           = try(cache.value.compression_enabled, null)
      content_types_to_compress     = try(cache.value.content_types_to_compress, null)
    }
  }
}
