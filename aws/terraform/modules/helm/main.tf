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

resource "kubernetes_namespace" "istio" {
  metadata {
    name = var.istio_namespace

    labels = {
      "istio-injection" = "enabled"
    }
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

# Istio Helm Release
resource "helm_release" "istio_base" {
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = kubernetes_namespace.istio.metadata[0].name
  create_namespace = false
  version          = var.istio_chart_version
  timeout          = 300

  depends_on = [kubernetes_namespace.istio]
}

resource "helm_release" "istio_discovery" {
  name             = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  namespace        = kubernetes_namespace.istio.metadata[0].name
  create_namespace = false
  version          = var.istio_chart_version
  timeout          = 600

  values = [
    templatefile("${path.module}/values/istio-discovery-values.yaml", {})
  ]

  depends_on = [helm_release.istio_base, kubernetes_namespace.istio]
}

resource "helm_release" "istio_ingress" {
  name             = "istio-ingressgateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  namespace        = kubernetes_namespace.istio.metadata[0].name
  create_namespace = false
  version          = var.istio_chart_version
  timeout          = 600
  wait             = true
  wait_for_jobs    = true

  values = [
    templatefile("${path.module}/values/istio-ingress-values.yaml", {})
  ]

  depends_on = [helm_release.istio_discovery]
}
