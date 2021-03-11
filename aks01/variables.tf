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