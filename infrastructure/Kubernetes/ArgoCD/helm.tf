resource "kubernetes_namespace" "argo" {
  metadata {
    name = "argo-cd"
  }
}
resource "helm_release" "argo" {
  name = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd" 
  namespace  = "argo-cd" 
  version    = "5.34.5"
}
