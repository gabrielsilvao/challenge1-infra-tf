variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "vpc-main"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "172.16.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks (/21)"
  type        = list(string)
  default     = ["172.16.0.0/21", "172.16.8.0/21", "172.16.16.0/21"]
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks (/21)"
  type        = list(string)
  default     = ["172.16.24.0/21", "172.16.32.0/21", "172.16.40.0/21"]
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets (false for HA with one per AZ)"
  type        = bool
  default     = true
}

# EKS Variables
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.33"
}

variable "instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

# Helm Addons Variables
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
