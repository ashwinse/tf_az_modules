variable "name" {}

variable "location" {}

variable "tags" {
  type = map(any)
}

variable "address_space" {
  type = list(any)
}

variable "resource_group_name" {}

variable "edge_zone" {
  default = null
}

variable "flow_timeout_in_minutes" {
  default = null
}

variable "is_ddos_protection_plan_enable" {
  default = null
}

variable "ddos_protection_plan_id" {
  default = null
}