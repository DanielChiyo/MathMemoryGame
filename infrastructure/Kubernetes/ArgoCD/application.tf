
resource "kubernetes_manifest" "argocd_application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "mmg"
      namespace = "argocd"
      finalizers = ["resources-finalizer.argocd.argoproj.io"] # Enables cascading deletion
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/DanielChiyo/MathMemoryGame.git"
        targetRevision = "HEAD"
        path           = "manifests"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "default"
      }
      syncPolicy = {
        automated = {
          prune      = true # Specifies if resources should be pruned during auto-syncing ( false by default ).
          selfHeal   = true
          allowEmpty = true # Allows deleting all application resources during automatic syncing ( false by default ).
        }
        syncOptions = [
          "Validate=true",               # disables resource validation (equivalent to 'kubectl apply --validate=false') ( true by default ).
          "CreateNamespace=true",          # Enable namespace auto-creation
          "PrunePropagationPolicy=foreground",  # Set pruning policy to foreground
          "PruneLast=true",                # Allow the ability for resource pruning to happen as a final, implicit wave of a sync operation
          "RespectIgnoreDifferences=false", # Respect the ignoreDifferences configuration during syncing
          "ApplyOutOfSyncOnly=true"        # Only sync out-of-sync resources, rather than applying every object in the application
        ]
      }
    }
  }
}

