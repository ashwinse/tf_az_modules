variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "tags" {
  type = map(any)
}
variable "disable_bgp_route_propagation" {
  default = null # true or false
}