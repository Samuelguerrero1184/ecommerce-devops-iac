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

