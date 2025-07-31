variable "subnet_info" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
  }))
  default = null
}

variable "pip_info" {
  type = map(object({
    name                = string
    resource_group_name = string
  }))
  default = null
}
variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "tags" {
  default = null
  type    = map(any)
}
variable "fips_enabled" {
  default = null
  type    = bool
}
variable "zones" {
  default = [null]
  type    = list(string)
}
variable "enable_http2" {
  default = null
  type    = bool
}
variable "force_firewall_policy_association" {
  default = null
  type    = bool
}
variable "firewall_policy_id" {
  default = null
}
# variable "authentication_certificate" {
#   default = [
#     {
#        name = "s.name"
#        data = ""
#     }
#   ]
# }
variable "authentication_certificate" {
  default = null
}
variable "redirect_configuration" {
  default = null
}
variable "autoscale_configuration" {
  default = null
}
variable "custom_error_configuration" {
  default = null
}
variable "is_waf_configuration_enabled" {
  default = null
}
variable "firewall_mode" {
  default = null
}
variable "rule_set_type" {
  default = null
}
variable "rule_set_version" {
  default = null
}
variable "file_upload_limit_mb" {
  default = null
}
variable "request_body_check" {
  default = null
}
variable "max_request_body_size_kb" {
  default = null
}
variable "ssl_certificate" {
  default = null
}

variable "is_global" {
  default = false
}
variable "request_buffering_enabled" {
  default = false
}
variable "response_buffering_enabled" {
  default = false
}
variable "is_identity" {
  default = false
}
variable "identity_type" {
  default = null
}
variable "identity_ids" {
  default = null
}
variable "sku_name" {}
variable "tier" {}
variable "capacity" {}
variable "gateway_ip_configuration" {}
variable "frontend_port" {}
variable "frontend_ip_configuration" {}
variable "backend_address_pool" {}
variable "backend_http_settings" {}
variable "http_listener" {}
variable "request_routing_rule" {}