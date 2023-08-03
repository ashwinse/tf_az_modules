variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "sku" {}               # "PerGB2018"
variable "retention_in_days" {} # 30 - 730 
variable "tags" {
  type = map(any)
}