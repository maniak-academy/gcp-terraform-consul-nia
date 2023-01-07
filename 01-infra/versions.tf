terraform {
  required_version = ">= 0.15.3, < 2.0"
}

provider "google" {
  credentials = file("./creds/tf-gcp-interview-373822-0cd65ff0f9a9.json")
  project     = var.project_id
  region      = var.region
}