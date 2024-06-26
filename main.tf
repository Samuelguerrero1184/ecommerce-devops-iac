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
  resource_group_name    = var.resource_group
  location               = azurerm_resource_group.ecommerce.location
  network_name           = var.network_name
  network_interface_name = var.network_interface_name
}

module "security_group" {
  source                  = "./modules/security_group"
  security_group_name     = var.security_group_name
  resource_group_location = azurerm_resource_group.ecommerce.location
  resource_group_name     = azurerm_resource_group.ecommerce.name
}

module "apigateway" {
  source                  = "./modules/api_gateway"
  apigateway_name         = var.apigateway_name
  resource_group_name     = azurerm_resource_group.ecommerce.name
  resource_group_location = azurerm_resource_group.ecommerce.location
  publisher_name          = var.publisher_name
  publisher_email         = var.publisher_email
  sku_name                = var.sku_name
  subnet_id               = module.network.apigatewaysubnet_id
  network_public_ip       = module.network.apigateway-ip_public_id
}

module "identity" {
  source              = "./modules/identity"
  name                = "myUserAssignedIdentity_Ecommerce"
  resource_group_name = azurerm_resource_group.ecommerce.name
  location            = azurerm_resource_group.ecommerce.location
}

module "secret_key_vault"{

  source                      = "./modules/secret_key_vault"
  key_vault_name              = "myKeyVault-109988"
  resource_group_name         = var.resource_group
  location                    = azurerm_resource_group.ecommerce.location
  enabled_for_disk_encryption = true
  purge_protection_enabled    = false
  soft_delete_retention_days  = 7
  sku_name                    = "standard"
  key_permissions             = ["Get", "Create", "List", "Delete", "Purge", "Recover", "SetRotationPolicy", "GetRotationPolicy"]
  secret_permissions          = ["Get", "Set", "List", "Delete", "Purge", "Recover"]
  certificate_permissions     = ["Get"]
  secret_names                = ["mySecret1", "mySecret2", "webserver-config", "webserver-properties"]
  secret_values               = ["szechuan", "shashlik", "config-value", "properties-value"]
  key_names                   = ["myKey1", "myKey2"]
  key_types                   = ["RSA", "RSA"]
  key_sizes                   = [2048, 2048]
  key_opts                    = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
  time_before_expiry          = "P30D"
  expire_after                = "P90D"
  notify_before_expiry        = "P29D"
  user_assigned_identity_principal_id = module.identity.principal_id
  aks_secret_provider_id      = module.aks_cluster.aks_secret_provider


}

module "aks_cluster" {
  source                          = "./modules/aks_cluster"
  cluster_name                    = var.cluster_name
  resource_group_name             = azurerm_resource_group.ecommerce.name
  resource_group_location         = azurerm_resource_group.ecommerce.location
  dns_prefix                      = var.dns_prefix
  node_pool_name                  = var.node_pool_name
  vm_size                         = var.vm_size
  identity_type                   = var.identity_type
  environment                     = var.environment
  aks_ingress_application_gateway = var.aks_ingress_application_gateway
  subnet_cidr                     = module.network.store_network_cidr
  secret_rotation_enabled         = true
}

module "container_registry" {
  source                  = "./modules/container_registry"
  container_name          = var.container_name
  resource_group          = azurerm_resource_group.ecommerce.name
  resource_group_location = azurerm_resource_group.ecommerce.location
  sku                     = "Standard"
}
/*
module "vm" {
  prefix           = var.prefix
  source           = "./modules/vm"
  subnet-id        = module.network.subnet_id
  resource_group   = azurerm_resource_group.ecommerce.name
  location         = azurerm_resource_group.ecommerce.location
  user             = var.user
  password         = var.password
  networkInterface = [module.network.network_interface_id]
}
*/

resource "azurerm_network_interface_security_group_association" "storeAsociation" {
  network_interface_id      = module.network.network_interface_id
  network_security_group_id = module.security_group.security_group_id
}

resource "azurerm_role_assignment" "ClusterRegistryConection" {
  principal_id                     = module.aks_cluster.kubelet_identity
  role_definition_name             = "AcrPull"
  scope                            = module.container_registry.container_registry_id
  skip_service_principal_aad_check = true
}
resource "azurerm_role_assignment" "ClusterRegistryPushConnection" {
  principal_id                     = module.aks_cluster.kubelet_identity
  role_definition_name             = "AcrPush"
  scope                            = module.container_registry.container_registry_id
  skip_service_principal_aad_check = true
}

/*
module "bastion_host" {
  source                  = "./modules/bastion_host"
  bastion_host_name       = var.bastion_host_name
  resource_group_name     = azurerm_resource_group.ecommerce.name
  resource_group_location = azurerm_resource_group.ecommerce.location
  subnet_id               = module.network.bastion_subnet_id
  public_ip_address_id    = module.network.bastion_public_id
}
*/
