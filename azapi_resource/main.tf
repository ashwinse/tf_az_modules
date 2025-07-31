resource "azapi_resource" "symbolicname" {
  type                      = var.type
  name                      = var.name
  location                  = var.location
  parent_id                 = var.parent_id
  tags                      = var.tags
  schema_validation_enabled = false
  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_ids
    }
  }

  body = var.body
}