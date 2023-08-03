variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "server_name" {}
variable "edition" {}
variable "dtu" {}
variable "db_dtu_min" {}
variable "db_dtu_max" {}
variable "pool_size" {}
variable "tags" {
  type = map(any)
}