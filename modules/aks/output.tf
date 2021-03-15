output "aks_host" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.host
}
output "aks_username" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.username
  sensitive = true
}
output "aks_password" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.password
  sensitive = true
}
output "aks_client_certificate" {
  value = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  sensitive = true
}
output "aks_client_key" {
  value = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  sensitive = true
}
output "aks_cluster_ca_certificate" {
  value = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  sensitive = true
}