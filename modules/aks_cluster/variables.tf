variable "cluster_name" {
    description = "Name for the Cluster"
}
variable "resource_group_location" {
    description = "Location for the resource group"
}
variable "resource_group_name" {
    description = "Name for the resource group"
}
variable "dns_prefix" {
    description = "DNS prefix for the cluster"
}
variable "node_pool_name" {
    type = string
    description = "Name for the node pool"
}
variable "vm_size" {
    description = "Size of the VM"
}
variable "identity_type" {
    description = "Type of identity"
}
variable "environment" {
    description = "Environment"
}
variable "aks_ingress_application_gateway" {
    description = "Ingress Application Gateway"
}
variable "subnet_cidr" {
    description = "Subnet CIDR"
}