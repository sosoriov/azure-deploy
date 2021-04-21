terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.50.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.10.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "0.0.13"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.2"
    }
    github = {
      source = "integrations/github"
      version = "4.9.2"
    }
  }
}

provider "azurerm" {
  features {

  }
}

provider "kubernetes" {
  host                   = module.aks-cluster.aks_host
  username               = module.aks-cluster.aks_username
  password               = module.aks-cluster.aks_password
  client_certificate     =module.aks-cluster.aks_client_certificate
  client_key             =module.aks-cluster.aks_client_key
  cluster_ca_certificate =module.aks-cluster.aks_cluster_ca_certificate
}

provider "kubectl" {
  host                   = module.aks-cluster.aks_host
  cluster_ca_certificate =module.aks-cluster.aks_cluster_ca_certificate
  token                  = module.aks-cluster.aks_password
  load_config_file       = false
}