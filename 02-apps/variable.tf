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
variable "spoke_vm_type" {
  description = "The GCP machine type for the compute instances in the spoke networks."
  type        = string
  default     = "f1-micro"
}

variable "public_key_path1" {
  description = "Local path to public SSH key.  If you do not have a public key, run >> ssh-keygen -f ~/.ssh/demo-key -t rsa -C admin"
  type        = string
  default     = null
}

variable "spoke_vm_image" {
  description = "The image path for the compute instances deployed in the spoke networks."
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2004-lts"
}

variable "spoke_vm_user" {
  description = "The username for the compute instance in the spoke networks."
  type        = string
  default     = null
}

variable "spoke_vm_scopes" {
  description = "A list of service scopes. Both OAuth2 URLs and gcloud short names are supported. To allow full access to all Cloud APIs, use the cloud-platform"
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write"
  ]
}


variable "cidr_ss" {
  description = "The CIDR range of the ss subnetwork."
  type        = string
  default     = null
}
variable "cidr_spoke1" {
  description = "The CIDR range of the management subnetwork."
  type        = string
  default     = null
}
variable "cidr_spoke2" {
  description = "The CIDR range of the spoke1 subnetwork."
  type        = string
  default     = null
}