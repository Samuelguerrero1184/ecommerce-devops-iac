resource "azurerm_application_gateway" "network" {
  name                = var.apigateway_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  sku {
    name     = var.sku_name
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "ecommerce-gateway-ip-configuration"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "ecommerce-frontend-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "ecommerce-frontend-ip-configurtation"
    public_ip_address_id = var.network_public_ip
  }

  backend_address_pool {
    name = "backend_adress_pool"
  }

  backend_http_settings {
    name                  = "ecommerce_http_settings"
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "ecommerce_http_listener"
    frontend_ip_configuration_name = "ecommerce-frontend-ip-configurtation"
    frontend_port_name             = "ecommerce-frontend-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "request_routing_rule_ecommerce"
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = "ecommerce_http_listener"
    backend_address_pool_name  = "backend_adress_pool"
    backend_http_settings_name = "ecommerce_http_settings"
  }
}