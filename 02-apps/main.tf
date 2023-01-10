
data "terraform_remote_state" "environment" {
  backend = "local"

  config = {
    path = "../01-infra/terraform.tfstate"
  }
}


provider "google" {
  credentials = file("./creds/tf-gcp-interview-373822-f78452d3049f.json")
  project     = data.terraform_remote_state.environment.outputs.project_id
  region      = data.terraform_remote_state.environment.outputs.region
}