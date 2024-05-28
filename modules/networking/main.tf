resource "azurerm_virtual_network" "avn-ecommerceG1" {
  name                = var.network_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}
resource "azurerm_subnet" "store" {
  name                 = "storeSubNet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.network_name
  address_prefixes     = ["10.0.2.0/24"]
}
### Bastion
/*
resource "azurerm_subnet" "bastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.network_name
  address_prefixes     = ["10.0.3.0/24"]
}
*/
resource "azurerm_subnet" "subnetApiGateway" {
  name                 = "${var.resource_group_name}-api-gateway-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.network_name
  address_prefixes     = ["10.0.4.0/24"]
}
resource "azurerm_public_ip" "ecommerce-ip" {
  name                = "${var.resource_group_name}-ecommerce-ecommerce-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"  # Ensure it's set to Standard
}

/*
resource "azurerm_public_ip" "bastion-ip" {
  name                = "bastion-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"  # or "Dynamic" depending on your needs
  sku                 = "Standard"
}
*/
resource "azurerm_network_interface" "storeInterface" {
  name                = var.network_interface_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.resource_group_name}-ani"
    subnet_id                     = azurerm_subnet.store.id
    private_ip_address_allocation = "Dynamic"
  }
}