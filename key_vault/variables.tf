variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "enabled_for_disk_encryption" {
  default = false
}
variable "tenant_id" {}
variable "enabled_for_deployment" {
  default = false
}
variable "enable_rbac_authorization" {
  default = null
}
variable "enabled_for_template_deployment" {
  default = null
}
variable "public_network_access_enabled" {
  default = true
}
variable "soft_delete_enabled" {
  default = false
}
variable "soft_delete_retention_days" {
  default = null
}
variable "purge_protection_enabled" {
  default = false
}
variable "sku_name" {} # standard or premium
variable "tags" {
  type = map(any)
}

variable "is_network_acls_req" {
  default = null
}
variable "network_acls_bypass" {
  default = "AzureServices"
}
variable "network_acls_default_action" {
  default = "Allow"
}
variable "ip_rules" {
  type    = list(any)
  default = null
}
variable "virtual_network_subnet_ids" {
  type    = list(any)
  default = null
}