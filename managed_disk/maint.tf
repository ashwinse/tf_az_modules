resource "azurerm_managed_disk" "md" {
  name                 = var.name
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.storage_account_type
  create_option        = var.create_option
  source_resource_id   = var.source_resource_id
  image_reference_id   = var.image_reference_id
  source_uri           = var.source_uri
  disk_size_gb         = var.disk_size_gb
  os_type              = var.os_type
  storage_account_id   = var.storage_account_id
  max_shares           = var.max_shares
  tags                 = var.tags

  lifecycle {
    ignore_changes = [tags]
  }
}