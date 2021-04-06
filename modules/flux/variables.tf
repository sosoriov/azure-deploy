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