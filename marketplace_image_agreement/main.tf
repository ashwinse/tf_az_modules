resource "azurerm_marketplace_agreement" "ma" {
  publisher = var.publisher
  offer     = var.offer
  plan      = var.plan
}