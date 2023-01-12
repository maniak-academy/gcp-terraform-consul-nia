

# --------------------------------------------------------------------------------------------------------------------------
# Create spoke2 web compute instances. 

resource "google_compute_instance" "spoke2_web" {
  count                     = var.web_count
  name                      = "spoke2-web${count.index + 1}"
  machine_type              = data.terraform_remote_state.environment.outputs.spoke_vm_type2
  zone                      = data.terraform_remote_state.environment.outputs.google_compute_zones
  can_ip_forward            = false
  allow_stopping_for_update = true

  metadata = {
    serial-port-enable = true
    ssh-keys           = fileexists(var.public_key_path1) ? "${data.terraform_remote_state.environment.outputs.spoke_vm_user}:${file(var.public_key_path1)}" : ""
  }
  metadata_startup_script = templatefile("${path.module}/scripts/startup-web.sh", {
    consul_version = "1.14.3"
  })

  network_interface {
    subnetwork = "us-central1-spoke2"
  }

  boot_disk {
    initialize_params {
      image = data.terraform_remote_state.environment.outputs.spoke_vm_image
    }
  }

  service_account {
    scopes = data.terraform_remote_state.environment.outputs.spoke_vm_scopes
  }
  depends_on = [
    google_compute_address.consul_external_ip
  ]
}
