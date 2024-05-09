resource "azurerm_container_registry" "containerRegistryBlue" {
  name                = var.container_name
  resource_group_name = var.resource_group
  location            = var.resource_group_location
  sku                 = var.sku
}