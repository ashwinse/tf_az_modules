variable "name" {}

variable "cdn_frontdoor_profile_id" {}

variable "dns_zone_id" {
  default = null
}

variable "host_name" {}

variable "certificate_type" {
  default = "ManagedCertificate"
}

variable "minimum_tls_version" {
  default = null
}