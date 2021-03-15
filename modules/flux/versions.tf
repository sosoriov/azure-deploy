terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
    flux = {
        source = "fluxcd/flux"
    }
  }
}