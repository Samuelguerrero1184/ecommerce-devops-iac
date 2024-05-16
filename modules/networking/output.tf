output "subnet_id" {
  value       = azurerm_subnet.store.id
  description = "description"
}
/*
output "bastion_subnet_id" {
    value = azurerm_subnet.bastionSubnet.id
    description = "description"
}
*/
output "network_interface_id" {
  value       = azurerm_network_interface.storeInterface.id
  description = "description"
}
output "network_public_id"{
  value = azurerm_public_ip.ecommerce-ip.id  
}
output "subnetApiGateway_id"{
    value = azurerm_subnet.subnetApiGateway.id
}
/*
output "bastion_public_id"{
  value = azurerm_public_ip.bastion-ip.id
}*/