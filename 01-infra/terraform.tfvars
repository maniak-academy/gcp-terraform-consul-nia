project_id      = "tf-gcp-interview-373822"
public_key_path = "~/.ssh/gcp-consuldemo.pub"
region          = "us-central1"
fw_image_name   = "vmseries-flex-bundle2-1010"
fw_machine_type = "n1-standard-4"
allowed_sources = ["0.0.0.0/0"]

cidr_mgmt    = "192.168.0.0/25"
cidr_untrust = "192.168.1.0/28"
cidr_trust   = "192.168.2.0/28"
cidr_spoke1  = "10.1.0.0/25"
cidr_spoke2  = "10.2.0.0/25"
cidr_ss      = "10.5.0.0/25"

spoke_vm_image = "https://www.googleapis.com/compute/v1/projects/panw-gcp-team-testing/global/images/ubuntu-2004-lts-apache"
spoke_vm_user  = "paloalto"