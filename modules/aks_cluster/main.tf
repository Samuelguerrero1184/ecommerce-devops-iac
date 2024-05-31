resource "azurerm_kubernetes_cluster" "clusterStore" {
  name                = var.cluster_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = var.node_pool_name
    node_count = 1
    vm_size    = var.vm_size
  }

  identity {
    #type = "SystemAssigned"
    type = var.identity_type
  }

  tags = {
    Environment = var.environment
  }

  key_vault_secrets_provider {
    # update the secrets on a regular basis
    secret_rotation_enabled = var.secret_rotation_enabled
  }
  #private_cluster_enabled = true

}
resource "local_file" "kubeconfig" {
  depends_on = [azurerm_kubernetes_cluster.clusterStore]
  filename   = "aksconfig"
  content    = azurerm_kubernetes_cluster.clusterStore.kube_config_raw
}

output "client_certificate-Store" {
  value     = azurerm_kubernetes_cluster.clusterStore.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config-Store" {
  value = azurerm_kubernetes_cluster.clusterStore.kube_config_raw

  sensitive = true
}