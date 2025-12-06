output "argocd_namespace" {
  description = "Kubernetes namespace where ArgoCD is installed"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "argo_rollouts_namespace" {
  description = "Kubernetes namespace where Argo Rollouts is installed"
  value       = kubernetes_namespace.argo_rollouts.metadata[0].name
}

output "kong_namespace" {
  description = "Kubernetes namespace where Kong is installed"
  value       = kubernetes_namespace.kong.metadata[0].name
}

output "argocd_release_status" {
  description = "Status of the ArgoCD Helm release"
  value       = helm_release.argocd.status
}

output "argo_rollouts_release_status" {
  description = "Status of the Argo Rollouts Helm release"
  value       = helm_release.argo_rollouts.status
}

output "kong_release_status" {
  description = "Status of the Kong Helm release"
  value       = helm_release.kong.status
}
