variable "project_id" {
  description = "GCP project ID"
  default     = null
}

variable "region" {
  description = "Google Cloud region for the created resources."
  type        = string
  default     = null
}

variable "public_key_path" {
  description = "Local path to public SSH key.  If you do not have a public key, run >> ssh-keygen -f ~/.ssh/demo-key -t rsa -C admin"
  type        = string
  default     = null
}