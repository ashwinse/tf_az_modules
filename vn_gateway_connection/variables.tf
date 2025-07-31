variable "configurations" {}
variable "location" {}
variable "resource_group_name" {}
variable "tags" {}
variable "subscription_id" {}
variable "virtual_network_gateways" {}
variable "express_route_circuits" {
  default = {}
}
variable "local_network_gateways" {
  default = {}
}
