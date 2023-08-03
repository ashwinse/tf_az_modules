variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "allocation_method" {} # Dynamic, Static
variable "tags" {
  type = map(any)
}
variable "domain_name_label" {
  default = null
}