variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "sku" {} #Basic, Standard
variable "public_ip_address_id" {
  default = null
}
variable "private_ip_address" {
  default = null
}
variable "private_ip_address_allocation" {
  default = null
}
variable "subnet_id" {
  default = null
}
variable "tags" {
  type = map(any)
}
variable "frontend_ip_configuration_name" {}

variable "sku_tier" {
  default = null
}