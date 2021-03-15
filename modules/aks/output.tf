output "aks_host" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.host
}
output "aks_username" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.username
}
output "aks_password" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.password
}
output "aks_client_certificate" {
  value = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
}
output "aks_client_key" {
  value = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
}
output "aks_cluster_ca_certificate" {
  value = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}