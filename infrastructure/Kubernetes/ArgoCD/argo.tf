resource "kubernetes_namespace" "argo" {
  metadata {
    name = "argocd"
  }
}
resource "helm_release" "argo" {
  name = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd" 
  namespace  = "argocd" 
  version    = "5.34.5"
  depends_on = [kubernetes_namespace.argo]
}
