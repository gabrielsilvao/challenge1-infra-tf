resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.argocd_namespace
  }
}

resource "kubernetes_namespace" "argo_rollouts" {
  metadata {
    name = var.argo_rollouts_namespace
  }
}

resource "kubernetes_namespace" "kong" {
  metadata {
    name = var.kong_namespace
  }
}

# ArgoCD Helm Release
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = kubernetes_namespace.argocd.metadata[0].name
  create_namespace = false
  version          = var.argocd_chart_version
  timeout          = 600

  values = [
    templatefile("${path.module}/values/argocd-values.yaml", {})
  ]

  depends_on = [kubernetes_namespace.argocd]
}

# Argo Rollouts Helm Release
resource "helm_release" "argo_rollouts" {
  name             = "argo-rollouts"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-rollouts"
  namespace        = kubernetes_namespace.argo_rollouts.metadata[0].name
  create_namespace = false
  version          = var.argo_rollouts_chart_version
  timeout          = 600

  values = [
    templatefile("${path.module}/values/argo-rollouts-values.yaml", {})
  ]

  depends_on = [kubernetes_namespace.argo_rollouts]
}

# Kong Ingress Controller Helm Release
resource "helm_release" "kong" {
  name             = "kong"
  repository       = "https://charts.konghq.com"
  chart            = "kong"
  namespace        = kubernetes_namespace.kong.metadata[0].name
  create_namespace = false
  version          = var.kong_chart_version
  timeout          = 600

  values = [
    templatefile("${path.module}/values/kong-values.yaml", {})
  ]

  depends_on = [kubernetes_namespace.kong]
}
