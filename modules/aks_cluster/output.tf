output "kubernetes_cluster_id" {
  value       = azurerm_kubernetes_cluster.clusterStore.id
  description = "The ID of the Kubernetes Cluster"

} 
output "kubelet_identity"{ 
  value = azurerm_kubernetes_cluster.clusterStore.kubelet_identity[0].object_id
  description = "The ID of the Kubernetes Cluster Identity"
}