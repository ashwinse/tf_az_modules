variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "subnet_resource_group_name" {}
variable "enable_ip_forwarding" {
  default = null
}
variable "enable_accelerated_networking" {
  default = null
}
variable "tags" {
  type    = map(any)
  default = null
}
variable "ip_configurations" {
  type    = map(any)
  default = null
}
variable "subscription_id" {
}
