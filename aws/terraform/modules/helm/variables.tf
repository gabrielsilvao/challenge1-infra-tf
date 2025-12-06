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

variable "istio_namespace" {
  description = "Kubernetes namespace for Istio"
  type        = string
  default     = "istio-system"
}

variable "istio_chart_version" {
  description = "Istio Helm chart version"
  type        = string
  default     = "1.18.0"
}
