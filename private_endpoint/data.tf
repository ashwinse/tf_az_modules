# locals {
#   private_dns_zone_names = var.private_dns_zone_group != null ? flatten(tolist([for k, v in var.private_dns_zone_group : "${v.private_dns_zone_ids}"])) : null
#   private_dns_zone_ids   = var.private_dns_zone_group != null ? flatten(tolist([for pdz in local.private_dns_zone_names : data.azurerm_private_dns_zone.pdz[pdz].id])) : null
# }

# data "azurerm_private_dns_zone" "pdz" {
#   for_each            = var.private_dns_zone_group != null ? { for pdz in local.private_dns_zone_names : pdz => pdz } : {}
#   name                = each.value
#   resource_group_name = var.resource_group_name
# }