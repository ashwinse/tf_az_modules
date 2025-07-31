variable "name" {}
variable "type" {}
variable "location" {}
variable "parent_id" {
  default = null
}
variable "tags" {
  default = null
}
variable "identity_type" {
  default = null
}
variable "identity_ids" {
  default = null
}
variable "body" {
  type        = any
  description = "Custom body of the resource as a JSON-encoded string."
}