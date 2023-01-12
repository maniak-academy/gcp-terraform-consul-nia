

# # --------------------------------------------------------------------------------------------------------------------------
# # Create vault compute instances. 

# resource "google_compute_address" "vault_external_ip" {
#   name   = "my-vault-static-ip-address"
#   region = "us-central1"
# }

# resource "google_compute_instance" "vault_vm1" {
#   name                      = "${local.prefix}vault-vm"
#   machine_type              = var.spoke_vm_type
#   zone                      = data.google_compute_zones.main.names[0]
#   can_ip_forward            = false
#   allow_stopping_for_update = true

#   metadata = {
#     serial-port-enable = true
#     ssh-keys           = fileexists(var.public_key_path) ? "${var.spoke_vm_user}:${file(var.public_key_path)}" : ""
#   }
#   metadata_startup_script = file("${path.module}/scripts/startup-vault.sh")

#   network_interface {
#     subnetwork = "us-central1-ss"
#     network_ip = cidrhost(var.cidr_ss, 60)
#     access_config {
#       nat_ip = google_compute_address.vault_external_ip.address
#     }
#   }

#   boot_disk {
#     initialize_params {
#       image = var.spoke_vm_image
#     }
#   }

#   service_account {
#     scopes = var.spoke_vm_scopes
#   }
# depends_on = [
#   module.vpc_mgmt

# ]
# }
