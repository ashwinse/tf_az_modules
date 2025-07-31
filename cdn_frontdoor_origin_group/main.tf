resource "azurerm_cdn_frontdoor_origin_group" "fdogp" {
  name                     = var.name
  cdn_frontdoor_profile_id = var.cdn_frontdoor_profile_id
  session_affinity_enabled = var.session_affinity_enabled

  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = var.restore_traffic_time_to_healed_or_new_endpoint_in_minutes


  dynamic "health_probe" {
    for_each = var.health_probe != null ? var.health_probe : {}
    content {
      interval_in_seconds = health_probe.value.interval_in_seconds
      path                = try(health_probe.value.path, null)
      protocol            = health_probe.value.protocol
      request_type        = try(health_probe.value.request_type, null)
    }
  }

  load_balancing {
    additional_latency_in_milliseconds = var.additional_latency_in_milliseconds
    sample_size                        = var.sample_size
    successful_samples_required        = var.successful_samples_required
  }
}