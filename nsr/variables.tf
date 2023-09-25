variable "name" {}
variable "priority" {}
variable "direction" {}                   # Inbound or Outbound
variable "access" {}                      # Allow or Deny
variable "protocol" {}                    # Tcp, Udp, Icmp, *
variable "source_port_range" {}           # *
variable "destination_port_range" {}      # *
variable "source_address_prefix" {}       # *
variable "destination_address_prefix" {}  # *
variable "resource_group_name" {}         # *
variable "network_security_group_name" {} # *
variable "source_port_ranges" {
  type    = list(any)
  default = [null]
}
variable "destination_port_ranges" {
  type    = list(any)
  default = [null]
}
variable "source_address_prefixes " {
  type    = list(any)
  default = [null]
}
variable "destination_address_prefixes" {
  type    = list(any)
  default = [null]
}