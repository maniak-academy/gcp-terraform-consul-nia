
# --------------------------------------------------------------------------------------------------------------------------
# Create ss compute instance consul

resource "google_compute_address" "consul_external_ip" {
  name   = "my-consul-static-ip-address"
  region = "us-central1"
}

resource "google_compute_instance" "ss_vm1_consul" {
  count                     = 1
  name                      = "ss-vm-consul${count.index + 1}"
  machine_type              = data.terraform_remote_state.environment.outputs.spoke_vm_type
  zone                      = data.terraform_remote_state.environment.outputs.google_compute_zones
  can_ip_forward            = false
  allow_stopping_for_update = true

  metadata = {
    serial-port-enable = true
    ssh-keys           = fileexists(var.public_key_path1) ? "${data.terraform_remote_state.environment.outputs.spoke_vm_user}:${file(var.public_key_path1)}" : ""
  }

  metadata_startup_script = templatefile("${path.module}/scripts/startup-consul.sh", {
    consul_version   = "1.14.3",
    panos_mgmt_addr1 = "${data.terraform_remote_state.environment.outputs.vmseries01_access}",
    panos_mgmt_addr2 = "${data.terraform_remote_state.environment.outputs.vmseries02_access}"
  })


  network_interface {
    subnetwork = "us-central1-ss"
    network_ip = cidrhost(var.cidr_ss, 99)
    access_config {
      nat_ip = google_compute_address.consul_external_ip.address
    }
  }

  boot_disk {
    initialize_params {
      image = data.terraform_remote_state.environment.outputs.spoke_vm_image
    }
  }

  service_account {
    scopes = data.terraform_remote_state.environment.outputs.spoke_vm_scopes
  }

}

