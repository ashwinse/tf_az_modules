variable "resource_group_name" {}
variable "loadbalancer_id" {}
variable "name" {}
variable "protocol" {}
variable "frontend_port_start" {}
variable "frontend_port_end" {}
variable "backend_port" {}
variable "frontend_ip_configuration_name" {}
variable "idle_timeout_in_minutes" {
  default = null
}
variable "floating_ip_enabled" {
  default = null
}
variable "tcp_reset_enabled" {
  default = null
}
