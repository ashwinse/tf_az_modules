variable "resource_group_name" {}
variable "loadbalancer_id" {}
variable "name" {}
variable "protocol" {}
variable "frontend_port" {}
variable "backend_port" {}
variable "frontend_ip_configuration_name" {}
variable "backend_address_pool_id" {
  default = null
}
variable "probe_id" {
  default = null
}
variable "enable_floating_ip" {
  default = null
}
variable "enable_tcp_reset" {
  default = null
}
variable "disable_outbound_snat" {
  default = null
}
variable "load_distribution" {
  default = null
}
variable "idle_timeout_in_minutes" {
  default = null
}
variable "backend_address_pool_ids" {
  default = null
  type    = list(any)
}
