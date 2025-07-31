variable "virtual_machines" {
  type = map(any)
}
variable "ssh_pub_key" {
  type    = string
  default = null
}