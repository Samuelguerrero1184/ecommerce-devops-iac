provider "azurerm" {
  features {

  }
}
resource "azurerm_resource_group" "ecommerce" {
  name     = var.resource_group
  location = var.location
}
resource "azurerm_api_management" "apigateway" {
  name                = "apigateway-ecommerce"
  location            = azurerm_resource_group.ecommerce.location
  resource_group_name = azurerm_resource_group.ecommerce.name
  publisher_name      = "Tecno Solucionesn't"
  publisher_email     = "company@terraform.io"

  sku_name = "Developer_1"
}

resource "azurerm_virtual_network" "avn" {
  name                = "Red-ecommerce"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.ecommerce.name
}
resource "azurerm_subnet" "store" {
  name                 = "${var.resource_group}-store"
  resource_group_name  = azurerm_resource_group.ecommerce.name
  virtual_network_name = azurerm_virtual_network.avn.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_subnet" "admin" {
  name                 = "${var.resource_group}-admin"
  resource_group_name  = azurerm_resource_group.ecommerce.name
  virtual_network_name = azurerm_virtual_network.avn.name
  address_prefixes     = ["10.0.3.0/24"]
}
resource "azurerm_subnet" "subnetfirewall" {
  name                 = "${var.resource_group}-subnetfirewall"
  resource_group_name  = azurerm_resource_group.ecommerce.name
  virtual_network_name = azurerm_virtual_network.avn.name
  address_prefixes     = ["10.0.4.0/24"]
}
resource "azurerm_public_ip" "ecommerce-ip" {
  name                = "${var.resource_group}-ecommerce-ecommerce-ip"
  resource_group_name = azurerm_resource_group.ecommerce.name
  location            = var.location
  allocation_method   = "Static"

}

resource "azurerm_network_security_group" "adminGroup" {
  name                = "adminGroup"
  location            = var.location
  resource_group_name = azurerm_resource_group.ecommerce.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "storeGroup" {
  name                = "storeGroup"
  location            = var.location
  resource_group_name = azurerm_resource_group.ecommerce.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


resource "azurerm_network_interface" "storeInterface" {
  name                = "storeInterface"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "${var.resource_group}-ani"
    subnet_id                     = azurerm_subnet.store.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ecommerce-ip.id
  }
}
/*
resource "azurerm_network_interface" "adminInterface" {
  name                = "adminInterface"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "${var.resource_group}-ani"
    subnet_id                     = azurerm_subnet.admin.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ecommerce-ip.id
  }
}

resource "azurerm_network_interface" "firewallInterface" {
  name                = "firewallInterface"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "${var.resource_group}-firewallInterface"
    subnet_id                     = azurerm_subnet.subnetfirewall.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ecommerce-ip.id
  }
}
*/

resource "azurerm_network_interface_security_group_association" "storeAsociation" {
  network_interface_id      = azurerm_network_interface.storeInterface.id
  network_security_group_id = azurerm_network_security_group.storeGroup.id
}

/*
resource "azurerm_network_interface_security_group_association" "adminAsociation" {
  network_interface_id      = azurerm_network_interface.adminInterface.id
  network_security_group_id = azurerm_network_security_group.adminGroup.id
}
*/
resource "azurerm_kubernetes_cluster" "clusterStore" {
  name                = "Store-Cluster"
  location            = azurerm_resource_group.ecommerce.location
  resource_group_name = azurerm_resource_group.ecommerce.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_role_assignment" "ClusterRegistryConection" {
  principal_id                     = azurerm_kubernetes_cluster.clusterStore.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.containerRegistryEcommerce.id
  skip_service_principal_aad_check = true
}

output "client_certificate-Store" {
  value     = azurerm_kubernetes_cluster.clusterStore.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config-Store" {
  value = azurerm_kubernetes_cluster.clusterStore.kube_config_raw

  sensitive = true
}

/*
resource "azurerm_kubernetes_cluster" "clusterAdmin" {
  name                = "Store-Cluster"
  location            = azurerm_resource_group.ecommerce.location
  resource_group_name = azurerm_resource_group.ecommerce.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate-Admin" {
  value     = azurerm_kubernetes_cluster.clusterAdmin.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config-Admin" {
  value = azurerm_kubernetes_cluster.clusterAdmin.kube_config_raw

  sensitive = true
}
*/
module "vm" {
  prefix           = "prueba"
  source           = "./modules/vm"
  subnet-id        = azurerm_subnet.store.id
  resource_group   = azurerm_resource_group.ecommerce.name
  location         = azurerm_resource_group.ecommerce.location
  user             = var.user
  password         = var.password
  networkInterface = [azurerm_network_interface.storeInterface.id]
}