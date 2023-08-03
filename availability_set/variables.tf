variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "platform_update_domain_count" {
  default = null //5
}
variable "platform_fault_domain_count" {
  default = null //3
}
variable "managed" {}
variable "tags" {}