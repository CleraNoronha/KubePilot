terraform {
  required_version = ">= 1.4.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
resource "terraform_data" "kubepilot" {
  input = {
    project     = "KubePilot"
    environment = "dev"
    purpose     = "Kubernetes platform automation and reliability"
  }
}
resource "kubernetes_namespace_v1" "kubepilot" {
  metadata {
    name = "kubepilot"

    labels = {
      "app.kubernetes.io/part-of" = "kubepilot"
    }
  }
}
