variable "name" {}

variable "cdn_frontdoor_endpoint_id" {}

variable "cdn_frontdoor_origin_group_id" {}

variable "cdn_frontdoor_origin_ids" {
  type = list(string)
}

variable "cdn_frontdoor_rule_set_ids" {
  type    = list(string)
  default = []
}

variable "is_route_enabled" {
  type = bool
}

variable "forwarding_protocol" {
  default = null
}

variable "https_redirect_enabled" {
  type = bool
}

variable "patterns_to_match" {
  type = list(string)
}

variable "supported_protocols" {
  type = list(string)
}

variable "cdn_frontdoor_custom_domain_ids" {
  type    = list(string)
  default = []
}

variable "link_to_default_domain" {
  type = bool
}

# variable "query_string_caching_behavior" {}

# variable "query_strings" {
#   type = list(string)
# }

# variable "compression_enabled" {
#   default = false
#   type    = bool
# }

# variable "content_types_to_compress" {
#   type = list(string)
# }

variable "cache" {
  default = null
}
