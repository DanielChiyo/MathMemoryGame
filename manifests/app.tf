resource "kubernetes_deployment_v1" "default" {
  metadata {
    name = "mmg-web-app-deployment"
  }

  spec {
    selector {
      match_labels = {
        app = "mmg-web-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "mmg-web-app"
        }
      }

      spec {
        container {
          image = "gcr.io/gcp-certification-lab-435613/mmg-web-app:latest"
          name  = "mmg-web-app-container"

          port {
            container_port = 80
            name           = "mmg-web-app-svc"
          }

          security_context {
            allow_privilege_escalation = false
            privileged                 = false
            read_only_root_filesystem  = false

            capabilities {
              add  = []
              drop = ["NET_RAW"]
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = "mmg-web-app-svc"

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }

        security_context {
          run_as_non_root = true

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        # Toleration is currently required to prevent perpetual diff:
        # https://github.com/hashicorp/terraform-provider-kubernetes/pull/2380
        toleration {
          effect   = "NoSchedule"
          key      = "kubernetes.io/arch"
          operator = "Equal"
          value    = "amd64"
        }
      }
    }
  }
}
