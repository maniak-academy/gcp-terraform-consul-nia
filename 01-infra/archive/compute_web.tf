

# --------------------------------------------------------------------------------------------------------------------------
# Create spoke2 compute instances. 

resource "google_compute_instance" "spoke2_web" {
  count                     = 3
  name                      = "${local.prefix}spoke2-web${count.index + 1}"
  machine_type              = var.spoke_vm_type
  zone                      = data.google_compute_zones.main.names[0]
  can_ip_forward            = false
  allow_stopping_for_update = true

  metadata = {
    serial-port-enable = true
    ssh-keys           = fileexists(var.public_key_path) ? "${var.spoke_vm_user}:${file(var.public_key_path)}" : ""
  }
  metadata_startup_script = templatefile("${path.module}/scripts/startup-web.sh", {
    consul_version = "1.14.3"
  })

  network_interface {
    subnetwork = module.vpc_spoke2.subnets_self_links[0]
  }

  boot_disk {
    initialize_params {
      image = var.spoke_vm_image
    }
  }

  service_account {
    scopes = var.spoke_vm_scopes
  }
  depends_on = [
    google_compute_address.consul_external_ip
  ]
}
