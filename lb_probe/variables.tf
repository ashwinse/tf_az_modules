variable "resource_group_name" {}
variable "loadbalancer_id" {}
variable "name" {}
variable "port" {}
variable "protocol" {
  default = null
}
variable "probe_threshold" {
  default = null
}
variable "interval_in_seconds" {
  default = null
}
variable "number_of_probes" {
  default = null
}