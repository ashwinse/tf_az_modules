output "private_ip_address" {
  value = try(module.vmw[0].*.private_ip_address, module.vml[0].*.private_ip_address)
}
output "public_ip_address" {
  value = try(module.vmw[0].*.public_ip_address, module.vml[0].*.public_ip_address)
}
output "virtual_machine_ids" {
  value = try(module.vmw[0].*.id, module.vml[0].*.id)
}
output "nic_ids" {
  value = module.nic
}
output "md_ids" {
  value = try(module.md, null)
}
output "principal_ids" {
  value = try(module.vmw[0].*.identity[0], module.vml[0].*.identity[0])
}