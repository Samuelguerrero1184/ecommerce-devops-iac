provider "azurerm" {
  features {

  }
}
resource "azurerm_resource_group" "ecommerce" {
  name     = var.resource_group
  location = var.location
}

module "network" {
  source                 = "./modules/networking"
  resource_group_name    = azurerm_resource_group.ecommerce.name
  location               = azurerm_resource_group.ecommerce.location
  network_name           = "Ecommerce_Network-Grupo1"
  network_interface_name = "Ecommerce_Network_Interface"
}

module "security_group" {
  source                  = "./modules/security_group"
  security_group_name     = "ecommerceSecurityGroup"
  resource_group_location = azurerm_resource_group.ecommerce.location
  resource_group_name     = azurerm_resource_group.ecommerce.name

}

module "apigateway" {
  source                  = "./modules/api_gateway"
  apigateway_name         = "ecommerceApiGateway"
  resource_group_name     = azurerm_resource_group.ecommerce.name
  resource_group_location = azurerm_resource_group.ecommerce.location
  sku_name                = "Standard_v2"
  sku_tier                = "Standard_v2"
  subnet_id               = module.network.subnetApiGateway_id
  frontend_port_name      = "ecommerceFrontendPort"
  frontend_ip_configuration_name = "ecommerceFrontendIPConfiguration"
  backend_address_pool_name = "ecommerceBackendAddressPool"
  http_setting_name = "ecommerceHttpSetting"
  listener_name = "ecommerceListener"
  request_routing_rule_name = "ecommerceRequestRoutingRule"
  public_ip_address_id = module.network.network_public_id
}

module "aks_cluster" {
  source                  = "./modules/aks_cluster"
  cluster_name            = "ecommerceCluster"
  resource_group_name     = azurerm_resource_group.ecommerce.name
  resource_group_location = azurerm_resource_group.ecommerce.location
  dns_prefix              = "ecommerce"
  node_pool_name          = "default"
  vm_size                 = "Standard_D2_v2"
  identity_type           = "SystemAssigned"
  environment             = "Production"
}

module "container_registry" {
  source                  = "./modules/container_registry"
  container_name          = "containerRegistryGrupo1"
  resource_group          = azurerm_resource_group.ecommerce.name
  resource_group_location = azurerm_resource_group.ecommerce.location
  sku                     = "Premium"
}
/*
module "vm" {
  prefix           = "prueba"
  source           = "./modules/vm"
  subnet-id        = module.network.subnet_id
  resource_group   = azurerm_resource_group.ecommerce.name
  location         = azurerm_resource_group.ecommerce.location
  user             = var.user
  password         = var.password
  networkInterface = [module.network.network_interface_id]
}

resource "azurerm_network_interface_security_group_association" "storeAsociation" {
  network_interface_id      = module.network.network_interface_id
  network_security_group_id = module.security_group.security_group_id
}
*/
resource "azurerm_role_assignment" "ClusterRegistryConection" {
  principal_id                     = module.aks_cluster.kubelet_identity
  role_definition_name             = "AcrPull"
  scope                            = module.container_registry.container_registry_id
  skip_service_principal_aad_check = true
}
/*
module "bastion_host" {
  source                  = "./modules/bastion_host"
  bastion_host_name       = "ecommerceBastionHost"
  resource_group_name     = azurerm_resource_group.ecommerce.name
  resource_group_location = azurerm_resource_group.ecommerce.location
  subnet_id               = module.network.bastion_subnet_id
  public_ip_address_id    = module.network.bastion_public_id
}
*/
