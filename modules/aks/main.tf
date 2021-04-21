resource "azurerm_resource_group" "main" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = var.cluster_name

  dynamic "default_node_pool" {
    for_each = ["default_node_pool_auto_scaled"]
    content {
      orchestrator_version  = var.k8s_version
      name                  = var.node_pool_name
      vm_size               = var.node_size
      os_disk_size_gb       = var.os_disk_size_gb
      vnet_subnet_id        = var.vnet_subnet_id
      enable_auto_scaling   = var.enable_auto_scaling
      max_count             = var.max_count
      min_count             = var.min_count
      enable_node_public_ip = var.enable_node_public_ip
      availability_zones    = var.nodes_availability_zones
      node_labels           = var.node_labels
      type                  = var.node_type
      max_pods              = var.max_pods
      tags                  = merge(var.tags, var.node_tags)
    }
  }

  identity {
    type = "SystemAssigned"
  }

  addon_profile {
    http_application_routing {
      enabled = var.enable_http_application_routing
    }

    kube_dashboard {
      enabled = var.enable_kube_dashboard
    }

    azure_policy {
      enabled = var.enable_azure_policy
    }

    oms_agent {
      enabled                    = var.enable_log_analytics_workspace
      log_analytics_workspace_id = var.enable_log_analytics_workspace ? azurerm_log_analytics_workspace.main-workspace[0].id : null
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      addon_profile,
    ]
  }
}

resource "azurerm_log_analytics_workspace" "main-workspace" {
  count               = var.enable_log_analytics_workspace ? 1 : 0
  name                = "${var.cluster_name}-log-analytics-workspace"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_retention_in_days

  tags = var.tags
}

resource "azurerm_log_analytics_solution" "main-solution" {
  count               = var.enable_log_analytics_workspace ? 1 : 0
  solution_name       = "ContainerInsights"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  workspace_name        = azurerm_log_analytics_workspace.main-workspace[0].name
  workspace_resource_id = azurerm_log_analytics_workspace.main-workspace[0].id

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

}


# FLUX

# provider "kubernetes" {
#   host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
#   username               = azurerm_kubernetes_cluster.aks.kube_config.0.username
#   password               = azurerm_kubernetes_cluster.aks.kube_config.0.password
#   client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
#   client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
#   cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
# }

# provider "kubectl" {
#   host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
#   cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
#   token                  = azurerm_kubernetes_cluster.aks.kube_config.0.password
#   load_config_file       = false
# }

