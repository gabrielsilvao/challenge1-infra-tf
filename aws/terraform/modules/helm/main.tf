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

# Metrics Server for HPA
resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = var.metrics_server_chart_version
  timeout    = 300

  set {
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
  }

  set {
    name  = "args[1]"
    value = "--kubelet-preferred-address-types=InternalIP"
  }
}

# Argo CD Image Updater
resource "helm_release" "argocd_image_updater" {
  name             = "argocd-image-updater"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-image-updater"
  namespace        = kubernetes_namespace.argocd.metadata[0].name
  create_namespace = false
  version          = var.argocd_image_updater_chart_version
  timeout          = 300

  values = [
    templatefile("${path.module}/values/argocd-image-updater-values.yaml", {
      aws_region = var.aws_region
    })
  ]

  depends_on = [helm_release.argocd, kubernetes_config_map.ecr_login_script]
}

# ConfigMap for ECR login script
resource "kubernetes_config_map" "ecr_login_script" {
  metadata {
    name      = "argocd-image-updater-ecr-login"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }

  data = {
    "ecr-login.sh" = <<-EOT
#!/bin/sh
aws ecr get-login-password --region ${var.aws_region}
EOT
  }

  depends_on = [kubernetes_namespace.argocd]
}
