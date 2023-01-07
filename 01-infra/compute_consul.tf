
# --------------------------------------------------------------------------------------------------------------------------
# Create spoke2 compute instance consul

resource "google_compute_address" "consul_external_ip" {
  name   = "my-consul-static-ip-address"
  region = "us-central1"
}

resource "google_compute_instance" "spoke2_vm1_consul" {
  count                     = 1
  name                      = "${local.prefix}spoke2-vm-consul${count.index + 1}"
  machine_type              = var.spoke_vm_type
  zone                      = data.google_compute_zones.main.names[0]
  can_ip_forward            = false
  allow_stopping_for_update = true

  metadata = {
    serial-port-enable = true
    ssh-keys           = fileexists(var.public_key_path) ? "${var.spoke_vm_user}:${file(var.public_key_path)}" : ""
  }

  metadata_startup_script = file("${path.module}/scripts/startup-consul.sh")

  network_interface {
    subnetwork = module.vpc_spoke2.subnets_self_links[0]
    network_ip = cidrhost(var.cidr_spoke2, 99)
    access_config {
      nat_ip = google_compute_address.consul_external_ip.address
    }
  }
  
  boot_disk {
    initialize_params {
      image = var.spoke_vm_image
    }
  }

  service_account {
    scopes = var.spoke_vm_scopes
  }

}
