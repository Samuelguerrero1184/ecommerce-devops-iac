resource "azurerm_virtual_network" "avn" {
  name                = var.network_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}
resource "azurerm_subnet" "store" {
  name                 = "${var.resource_group_name}-store"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.network_name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_subnet" "admin" {
  name                 = "${var.resource_group_name}-admin"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.network_name
  address_prefixes     = ["10.0.3.0/24"]
}
resource "azurerm_subnet" "subnetfirewall" {
  name                 = "${var.resource_group_name}-subnetfirewall"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.network_name
  address_prefixes     = ["10.0.4.0/24"]
}
resource "azurerm_public_ip" "ecommerce-ip" {
  name                = "${var.resource_group_name}-ecommerce-ecommerce-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"

}
resource "azurerm_network_interface" "storeInterface" {
  name                = var.network_interface_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.resource_group_name}-ani"
    subnet_id                     = azurerm_subnet.store.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ecommerce-ip.id
  }
}