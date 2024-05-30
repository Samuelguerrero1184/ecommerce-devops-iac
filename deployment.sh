#!/bin/bash

# Salir inmediatamente si un comando falla
set -e

# Obtener el nombre del grupo de recursos
resourceGroupName=$(terraform output -raw resource_group_name)
if [ -z "$resourceGroupName" ]; then
  echo "Error: No se pudo obtener el nombre del grupo de recursos."
  exit 1
fi

# Obtener el nombre de la aplicación de la puerta de enlace de aplicaciones
applicationGatewayName=$(terraform output -raw application_gateway_name)
if [ -z "$applicationGatewayName" ]; then
  echo "Error: No se pudo obtener el nombre de la puerta de enlace de aplicaciones."
  exit 1
fi

# Obtener el nombre del cluster
clusterName=$(terraform output -raw cluster_name)
if [ -z "$clusterName" ]; then
  echo "Error: No se pudo obtener el nombre del cluster."
  exit 1
fi

# Ejecutar el comando de Azure CLI con los valores obtenidos
appgwId=$(az network application-gateway list -g "$resourceGroupName" --query "[?name=='$applicationGatewayName'].id" -o tsv)
if [ -z "$appgwId" ]; then
  echo "Error: No se pudo obtener el ID de la puerta de enlace de aplicaciones."
  exit 1
fi

# Verificar los valores antes de ejecutar comandos adicionales
echo "Valores obtenidos:"
echo "Resource Group Name: $resourceGroupName"
echo "Application Gateway Name: $applicationGatewayName"
echo "Cluster Name: $clusterName"
echo "Application Gateway ID: $appgwId"

# Habilita los addons para la puerta de enlace de aplicaciones
echo "Habilitando addons para la puerta de enlace de aplicaciones..."
az aks enable-addons -n "$clusterName" -g "$resourceGroupName" -a ingress-appgw --appgw-id "$appgwId" || {
  echo "Error: Falló la habilitación de addons para la puerta de enlace de aplicaciones."
  exit 1
}

# Activa el managed identity
echo "Activando managed identity..."
az aks update -g "$resourceGroupName" -n "$clusterName" --enable-managed-identity || {
  echo "Error: Falló la activación del managed identity."
  exit 1
}

# Imprimir los valores de las variables
echo "Resource Group Name: $resourceGroupName"
echo "Application Gateway Name: $applicationGatewayName"
echo "Cluster Name: $clusterName"
echo "Application Gateway ID: $appgwId"
