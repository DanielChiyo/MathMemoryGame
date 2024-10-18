/*
resource "kubernetes_namespace" "argo" {
  metadata {
    name = "argo-cd"
  }
}
resource "helm_release" "argo" {
  name = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd" 
  namespace  = "default" 
  version    = "5.34.5"

  depends_on = [module.gke-autopilot, kubernetes_namespace.argo]
}
*/