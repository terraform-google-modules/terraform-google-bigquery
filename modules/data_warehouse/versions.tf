terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.52.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}