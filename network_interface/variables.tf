variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "enable_ip_forwarding" {
  default = null
}
variable "enable_accelerated_networking" {
  default = null
}
variable "ip_configuration_name" {}
variable "subnet_id" {
  default = null
}
variable "private_ip_address_allocation" {}
variable "private_ip_address" {
  default = null
}
variable "public_ip_address_id" {
  default = null
}
variable "tags" {
  type    = map(any)
  default = null
}