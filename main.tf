terraform {
  required_providers {
    kubernetes = {}
  }
}

resource "kubernetes_deployment" "this" {
  metadata {
    name      = "postgres"
    namespace = var.namespace
  }

  spec {

    replicas = 1

    selector {
      match_labels = {
        "app" = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          "app" = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = var.image

          port {
            container_port = 5432
          }

          env {
            name  = "POSTGRES_DB"
            value = var.database
          }

          env {
            name  = "POSTGRES_USER"
            value = var.username
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value = var.password
          }

          volume_mount {
            name       = "storage"
            mount_path = "/var/lib/postgresql/data"
          }
        }

        volume {
          name = "storage"
          persistent_volume_claim {
            claim_name = var.pvc
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "this" {
  metadata {
    name      = "postgres"
    namespace = var.namespace
    labels = {
      "app" = "postgres"
    }
  }

  spec {
    selector = {
      "app" = "postgres"
    }

    port {
      port = 5432
    }
  }
}


