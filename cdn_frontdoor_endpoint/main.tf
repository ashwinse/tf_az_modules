resource "azurerm_cdn_frontdoor_endpoint" "fdep" {
  name                     = var.name
  cdn_frontdoor_profile_id = var.cdn_frontdoor_profile_id
  tags                     = var.tags
}