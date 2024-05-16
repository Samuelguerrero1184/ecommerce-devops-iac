variable "apigateway_name" {
    description = "Name for the API Gateway"
}
variable "resource_group_location"{
    description = "Location for the resource group"
}
variable "resource_group_name" {
    description = "Name for the resource group"
}
variable "sku_name" {
    description = "SKU name"
}
variable "sku_tier" {
    description = "SKU tier"
}
variable "frontend_port_name" {
    description = "Name for the frontend port"
}
variable "subnet_id"{
    description = "ID for the subnet"
}
variable "frontend_ip_configuration_name" {
    description = "Name for the frontend IP configuration"
}
variable "backend_address_pool_name" {
    description = "Name for the backend address pool"
}
variable "http_setting_name" {
    description = "Name for the HTTP setting"
}
variable "listener_name"{
    description = "Name for the listener"
}
variable "request_routing_rule_name"{
    description = "Name for the request routing rule"
}
variable "public_ip_address_id"{
    description = "ID for the public IP address"
}