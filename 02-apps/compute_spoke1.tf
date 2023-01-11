
# --------------------------------------------------------------------------------------------------------------------------
# Create spoke1 compute instances with internal load balancer

resource "google_compute_instance" "spoke1_vm" {
  count                     = 2
  name                      = "spoke1-vm${count.index + 1}"
  machine_type              = data.terraform_remote_state.environment.outputs.spoke_vm_type
  zone                      = data.terraform_remote_state.environment.outputs.google_compute_zones
  can_ip_forward            = false
  allow_stopping_for_update = true

  metadata = {
    serial-port-enable = true
    ssh-keys           = fileexists(var.public_key_path1) ? "${data.terraform_remote_state.environment.outputs.spoke_vm_user}:${file(var.public_key_path1)}" : ""
  }

  metadata_startup_script = templatefile("${path.module}/scripts/startup-app.sh", {
    consul_version = "1.14.3"
  })
  network_interface {
    subnetwork = "us-central1-spoke1"
    #network_ip = cidrhost(var.cidr_spoke1, 10)
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


resource "google_compute_instance_group" "spoke1_ig" {
  name = "spoke1-ig"
  zone = data.terraform_remote_state.environment.outputs.google_compute_zones

  instances = google_compute_instance.spoke1_vm.*.id
}

module "spoke1_ilb" {
  source = "PaloAltoNetworks/vmseries-modules/google//modules/lb_internal"

  name       = "spoke1-ilb"
  backends   = { 0 = google_compute_instance_group.spoke1_ig.self_link }
  ip_address = cidrhost(var.cidr_spoke1, 10)
  subnetwork = "us-central1-spoke1"
  network    = data.terraform_remote_state.environment.outputs.vpc_spoke1_network_id

  all_ports = false

  timeout_sec       = 1
  ports             = [80]
  health_check_port = 80

}
