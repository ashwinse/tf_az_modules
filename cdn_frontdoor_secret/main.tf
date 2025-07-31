# resource "azurerm_cdn_frontdoor_secret" "fd_secret" {
#   name                     = var.name
#   cdn_frontdoor_profile_id = var.cdn_frontdoor_profile_id

#   secret {
#     customer_certificate {
#       key_vault_certificate_id = var.key_vault_certificate_id
#     }
#   }
# }