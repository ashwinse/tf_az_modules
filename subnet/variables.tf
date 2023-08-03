
variable "name" {}
variable "resource_group_name" {}
variable "virtual_network_name" {}
variable "address_prefixes" {
  type = list(any)
}
variable "private_endpoint_network_policies_enabled" {
  default = null
}
variable "private_link_service_network_policies_enabled" {
  default = null
}
variable "service_endpoints" {
  default = null
  type    = list(any)
}
variable "service_endpoint_policy_ids" {
  default = null
  type    = list(any)
}
variable "is_delegation" {
  default = null
}
variable "delegation_name" {
  default = null
}
variable "service_delegation_name" {
  default = null
}
variable "service_delegation_actions" {
  type    = list(any)
  default = null
}