terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.47.0"
    }
  }
}

provider "google" {
  credentials = file("<NAME>.json")
  project     = "gcp-event-driven-interview"
  region      = "us-central1"
}