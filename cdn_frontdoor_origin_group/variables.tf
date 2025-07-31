variable "name" {
  description = "The name of the origin group"
  type        = string
}

variable "cdn_frontdoor_profile_id" {
  description = "The ID of the CDN Front Door profile"
  type        = string
}

variable "session_affinity_enabled" {
  description = "Boolean flag to enable session affinity"
  type        = bool
  default     = true
}

variable "restore_traffic_time_to_healed_or_new_endpoint_in_minutes" {
  description = "Time to restore traffic to a healed or new endpoint"
  type        = number
  default     = 0
}

# variable "enable_health_probe" {
#   description = "Boolean flag to enable health probe"
#   type        = bool
#   default     = false
# }

# variable "health_probe_interval_in_seconds" {
#   description = "Interval for the health probe in seconds"
#   type        = number
#   default     = 240
# }

# variable "health_probe_path" {
#   description = "Path for the health probe"
#   type        = string
#   default     = "/"
# }

# variable "health_probe_protocol" {
#   description = "Protocol for the health probe"
#   type        = string
#   default     = "Https"
# }

# variable "health_probe_request_type" {
#   description = "Request type for the health probe"
#   type        = string
#   default     = "HEAD"
# }

variable "health_probe" {
  description = "Health probe configuration"
  default     = null
}


variable "additional_latency_in_milliseconds" {
  description = "Additional latency in milliseconds for load balancing"
  type        = number
  default     = 50
}

variable "sample_size" {
  description = "Sample size for load balancing"
  type        = number
  default     = 4
}

variable "successful_samples_required" {
  description = "Number of successful samples required for load balancing"
  type        = number
  default     = 3
}
