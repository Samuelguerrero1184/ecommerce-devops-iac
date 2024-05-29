variable "resource_group" {

  type        = string
  default     = "resourceGroup"
  description = "resource group"
}
variable "location" {
  type        = string
  default     = "West Europe"
  description = "Location"
}
variable "vm_name" {

  type        = string
  default     = "maquinaprueba"
  description = "Nombre de la maquina"

}

variable "security_group" {

  type        = string
  default     = "grupoDeSeguridad"
  description = "Grupo de Seguridad"

}

variable "user" {

  type        = string
  default     = "user"
  description = "User"
}
variable "password" {

  type        = string
  default     = "password"
  description = "password"
}

variable "network_name" {
  description = "The name of the network"
  type        = string
}

variable "network_interface_name" {
  description = "The name of the network interface"
  type        = string
}

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
}

variable "apigateway_name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "publisher_name" {
  description = "The name of the publisher"
  type        = string
}

variable "publisher_email" {
  description = "The email of the publisher"
  type        = string
}

variable "sku_name" {
  description = "The SKU name for the API Gateway"
  type        = string
}

variable "cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "dns_prefix" {
  description = "The DNS prefix for the AKS cluster"
  type        = string
}

variable "node_pool_name" {
  description = "The name of the node pool"
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
}

variable "identity_type" {
  description = "The type of identity assigned"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "container_name" {
  description = "The name of the container registry"
  type        = string
}

variable "sku" {
  description = "The SKU for the container registry"
  type        = string
}

variable "prefix" {
  description = "The prefix for VM resources"
  type        = string
}

variable "bastion_host_name" {
  description = "The name of the Bastion Host"
  type        = string
}

variable "aks_ingress_application_gateway" {
  description = "The name of the Ingress Application Gateway"
  type        = string
}