resource "azurerm_resource_group" "main" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = var.cluster_name

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_V2"
  }

  identity {
    type = "SystemAssigned"
  }

  addon_profile {
    oms_agent {
      enabled                    = var.enable_log_analytics_workspace
      log_analytics_workspace_id = var.enable_log_analytics_workspace ? azurerm_log_analytics_workspace.main-workspace[0].id : null
    }
  }

  tags = var.tags
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

}