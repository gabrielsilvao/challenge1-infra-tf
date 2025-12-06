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

variable "argocd_image_updater_chart_version" {
  description = "Argo CD Image Updater Helm chart version"
  type        = string
  default     = "0.9.6"
}

variable "aws_region" {
  description = "AWS region for ECR"
  type        = string
  default     = "us-east-1"
}

# Datadog Variables
variable "datadog_enabled" {
  description = "Enable Datadog Operator installation"
  type        = bool
  default     = false
}

variable "datadog_namespace" {
  description = "Kubernetes namespace for Datadog"
  type        = string
  default     = "datadog"
}

variable "datadog_chart_version" {
  description = "Datadog Helm chart version"
  type        = string
  default     = "3.49.0"
}

variable "datadog_api_key" {
  description = "Datadog API Key (sensitive)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "datadog_site" {
  description = "Datadog site (datadoghq.com, datadoghq.eu, etc.)"
  type        = string
  default     = "datadoghq.com"
}

variable "cluster_name" {
  description = "Name of the EKS cluster for Datadog tagging"
  type        = string
  default     = "eks-cluster"
}
