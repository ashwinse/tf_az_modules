variable "key_vault_id" {}
variable "tenant_id" {}
variable "object_id" {}
variable "key_permissions" {
  type = list(any)
}
variable "secret_permissions" {
  type    = list(any)
  default = null
}
variable "certificate_permissions" {
  type    = list(any)
  default = null
}