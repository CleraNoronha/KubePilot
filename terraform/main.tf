terraform {
  required_version = ">= 1.4.0"
}

resource "terraform_data" "kubepilot" {
  input = {
    project     = "KubePilot"
    environment = "dev"
    purpose     = "Kubernetes platform automation and reliability"
  }
}
