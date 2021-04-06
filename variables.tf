variable "resource_group" {
  type        = string
  description = "Resource group"
}

variable "location" {
  type        = string
  description = "Azure location"

  default = "West Europe"
}


variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "enable_log_analytics_workspace" {
  type        = bool
  description = "Enable the creation of enable_log_analytics_workspace and solution"
  default     = true
}

variable "log_analytics_workspace_sku" {
  type        = string
  description = "Sku plan"
  default     = "Free"
}

variable "log_retention_in_days" {
  type        = number
  description = "Retention log"
  default     = 7
}

variable "tags" {
  type        = map(string)
  description = "Any tags that should be present in all resources"
  default     = {}
}

variable "k8s_version" {
  type        = string
  description = "Specify which Kubernetes release to use for the orchestration layer. The default used is the latest Kubernetes version available in the region"
  default     = null
}

variable "node_pool_name" {
  type        = string
  description = "Default AKS agentpool name"
  default     = "nodepool"
}

variable "node_size" {
  type        = string
  description = "The default virtual machine size for the Kubernetes agents"
  default     = "Standard_D2s_v3"
}

variable "os_disk_size_gb" {
  type        = number
  description = "Disk size of nodes in Gb"
  default     = 50
}

variable "vnet_subnet_id" {
  type        = string
  description = "(Optional) The ID of a Subnet where the Kubernetes Node Pool should exist. Changing this forces a new resource to be created."
  default     = null
}

variable "enable_auto_scaling" {
  type        = bool
  description = "Enable node autoscaling"
  default     = true
}

variable "max_count" {
  type        = number
  description = "(Required) The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000"
  default     = 3
}

variable "min_count" {
  type        = number
  description = "(Required) The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100"
  default     = 1
}

variable "enable_node_public_ip" {
  type        = bool
  description = "(Optional) Should nodes in this Node Pool have a Public IP Address?"
  default     = false
}

variable "nodes_availability_zones" {
  type        = list(number)
  description = "A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created"
  default     = [1, 2, 3]
}

variable "node_labels" {
  type        = map(string)
  description = "A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created"
  default     = {}
}

variable "node_type" {
  type        = string
  description = "The type of Node Pool which should be created. Possible values are AvailabilitySet and VirtualMachineScaleSets. Defaults to VirtualMachineScaleSets."
  default     = "VirtualMachineScaleSets"
}

variable "max_pods" {
  type        = number
  description = "The maximum number of pods that can run on each agent. Changing this forces a new resource to be created"
  default     = null
}

variable "node_tags" {
  type        = map(string)
  description = "A mapping tags to assign to the Node Pool"
  default = {
    "aks-node-pool" = "true"
  }
}


# github config
variable "github_owner" {
  type        = string
  description = "Github username"
  default     = "sosoriov"
}

variable "github_token" {
  type        = string
  description = "Github token"
}

variable "repository_name" {
  type        = string
  description = "Repository name for Flux sync"
  default     = "flux-aks01"
}

variable "repository_visibility" {
  type    = string
  default = "public"
}

variable "branch" {
  type    = string
  default = "main"
}

variable "target_path" {
  type    = string
  default = "cl-seboso01"
}