variable "prefix" {
  type        = string
  description = "Prefix for resource names"
}
variable "resource_group"{

    type = string
    default = "resourceGroup"
    description = "resource group"
}
variable "location"{

     type = string
    default = "location"
    description = "Location"
}
variable "user"{

     type = string
    default = "user"
    description = "User"
}
variable "password"{

     type = string
    default = "password"
    description = "password"
}
variable "vm_name"{

  type = string
  default = "maquinaprueba"
  description = "Nombre de la maquina"

}
variable "subnet-id" {
  type        = string
  description = "Subnet ID"
}
variable "networkInterface"{

  type = list(string)
  description = "Network Interface"
}

