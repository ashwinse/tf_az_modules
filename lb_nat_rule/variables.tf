variable "resource_group_name" {}
variable "loadbalancer_id" {}
variable "name" {}
variable "protocol" {}
variable "frontend_port" {}
variable "backend_port" {}
variable "frontend_ip_configuration_name" {}

variable "frontend_port_start" {
  default = null
}

variable "frontend_port_end" {
  default = null
}

variable "backend_address_pool_id" {
  default = null
}

variable "idle_timeout_in_minutes" {
  default = null
}
variable "enable_floating_ip" {
  default = null
}
variable "enable_tcp_reset" {
  default = null
}
