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

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  username               = azurerm_kubernetes_cluster.aks.kube_config.0.username
  password               = azurerm_kubernetes_cluster.aks.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}

provider "kubectl" {
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  token                  = azurerm_kubernetes_cluster.aks.kube_config.0.password
  load_config_file       = false
}

# provider "github" {
#   owner = var.github_owner
#   token = var.github_token
# }

# # SSH
# locals {
#   known_hosts = "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="
# }

# resource "tls_private_key" "main" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }



# Generate manifests
data "flux_install" "main" {
  target_path    = "clusters/seboso01"
  network_policy = false
}

# data "flux_sync" "main" {
#   target_path = "clusters/seboso01"
#   url         = "ssh://git@github.com/${var.github_owner}/${var.repository_name}.git"
#   branch      = var.branch
# }

resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

# data "kubectl_file_documents" "install" {
#   content = data.flux_install.main.content
# }

# data "kubectl_file_documents" "sync" {
#   content = data.flux_sync.main.content
# }

# Split multi-doc YAML with
# https://registry.terraform.io/providers/gavinbunney/kubectl/latest
# data "kubectl_file_documents" "apply" {
#   content = data.flux_install.main.content
# }

# locals {
#   install = [for v in data.kubectl_file_documents.install.documents : {
#     data : yamldecode(v)
#     content : v
#     }
#   ]

  # sync = [for v in data.kubectl_file_documents.sync.documents : {
  #   data : yamldecode(v)
  #   content : v
  #   }
  # ]
# }

# resource "kubectl_manifest" "install" {
#   for_each   = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
#   depends_on = [kubernetes_namespace.flux_system]
#   yaml_body  = each.value
# }

# resource "kubectl_manifest" "sync" {
#   for_each   = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
#   depends_on = [kubernetes_namespace.flux_system]
#   yaml_body  = each.value
# }

# # GitHub
# resource "github_repository" "main" {
#   name       = var.repository_name
#   visibility = var.repository_visibility
#   auto_init  = true
# }

# resource "github_branch_default" "main" {
#   repository = github_repository.main.name
#   branch     = var.branch
# }

# resource "github_repository_deploy_key" "main" {
#   title      = "staging-cluster"
#   repository = github_repository.main.name
#   key        = tls_private_key.main.public_key_openssh
#   read_only  = true
# }

# resource "github_repository_file" "install" {
#   repository = github_repository.main.name
#   file       = data.flux_install.main.path
#   content    = data.flux_install.main.content
#   branch     = var.branch
# }