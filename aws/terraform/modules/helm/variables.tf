variable "cluster_id" {
  description = "EKS cluster ID (for dependency management)"
  type        = string
}

variable "argocd_namespace" {
  description = "Kubernetes namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "ArgoCD Helm chart version"
  type        = string
  default     = "5.46.0"
}

variable "argo_rollouts_namespace" {
  description = "Kubernetes namespace for Argo Rollouts"
  type        = string
  default     = "argo-rollouts"
}

variable "argo_rollouts_chart_version" {
  description = "Argo Rollouts Helm chart version"
  type        = string
  default     = "2.32.0"
}

variable "kong_namespace" {
  description = "Kubernetes namespace for Kong"
  type        = string
  default     = "kong"
}

variable "kong_chart_version" {
  description = "Kong Helm chart version"
  type        = string
  default     = "2.33.0"
}

variable "metrics_server_chart_version" {
  description = "Metrics Server Helm chart version"
  type        = string
  default     = "3.12.0"
}
