terraform {
  required_providers {
    kubernetes = {}
  }
}

resource "kubernetes_deployment" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {

    replicas = 1

    selector {
      match_labels = {
        "app" = var.name
      }
    }

    template {
      metadata {
        labels = {
          "app" = var.name
        }
      }

      spec {
        container {
          name  = var.name
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
    name      = var.name
    namespace = var.namespace
    labels = {
      "app" = var.name
    }
  }

  spec {
    selector = {
      "app" = var.name
    }

    port {
      port = 5432
    }
  }
}


