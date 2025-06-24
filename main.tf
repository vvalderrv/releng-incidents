terraform {
  required_providers {
    incident = {
      source  = "incident-io/incident"
      version = "= 5.8.0"
    }
  }
  required_version = ">= 0.13"
}

provider "incident" {
  api_key = var.incident_api_key
}
