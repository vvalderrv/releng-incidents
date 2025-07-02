terraform {
  required_providers {
    incident = {
      source  = "incident-io/incident"
      version = "~> 5.9"
    }
  }
  required_version = ">= 0.13"
}

provider "incident" {}
