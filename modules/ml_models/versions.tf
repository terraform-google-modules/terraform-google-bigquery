terraform {
  required_version = ">= 1.3"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0, < 9.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9, < 1.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.4, < 4.0"
    }
  }
}
