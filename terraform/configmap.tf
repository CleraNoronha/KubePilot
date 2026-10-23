resource "kubernetes_config_map_v1" "kubepilot_config" {
  metadata {
    name      = "kubepilot-config"
    namespace = "kubepilot"

    labels = {
      "app.kubernetes.io/part-of"    = "kubepilot"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  data = {
    APP_ENV   = "development"
    APP_NAME  = "kubepilot-health"
    LOG_LEVEL = "info"
  }
}
