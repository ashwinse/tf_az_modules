variable "name" {}

variable "cdn_frontdoor_origin_group_id" {}

variable "is_enabled" {
  type    = bool
  default = true
}

variable "certificate_name_check_enabled" {}

variable "host_name" {}

variable "http_port" {
  default = 80
}

variable "https_port" {
  default = 443
}

variable "origin_host_header" {
  default = null
}

variable "priority" {
  default = null
}

variable "weight" {
  default = null
}