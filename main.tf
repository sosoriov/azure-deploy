module "aks-cluster" {
  source = "./modules/aks"

  resource_group                 = var.resource_group
  location                       = var.location
  cluster_name                   = var.cluster_name
  enable_log_analytics_workspace = var.enable_log_analytics_workspace
  log_analytics_workspace_sku    = var.log_analytics_workspace_sku
  log_retention_in_days          = var.log_retention_in_days
  tags                           = var.tags
  k8s_version                    = var.k8s_version
  node_pool_name                 = var.node_pool_name
  node_size                      = var.node_size
  os_disk_size_gb                = var.os_disk_size_gb
  vnet_subnet_id                 = var.vnet_subnet_id
  enable_auto_scaling            = var.enable_auto_scaling
  max_count                      = var.max_count
  min_count                      = var.min_count
  enable_node_public_ip          = var.enable_node_public_ip
  nodes_availability_zones       = var.nodes_availability_zones
  node_labels                    = var.node_labels
  node_type                      = var.node_type
  max_pods                       = var.max_pods
  node_tags                      = var.node_tags
}

module "provision-flux" {
  source                = "./modules/flux"
  github_owner          = var.github_owner
  github_token          = var.github_token
  repository_name       = var.repository_name
  repository_visibility = var.repository_visibility
  branch                = var.branch
  target_path           = var.target_path
}