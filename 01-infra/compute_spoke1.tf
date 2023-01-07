
# --------------------------------------------------------------------------------------------------------------------------
# Create spoke1 compute instances with internal load balancer

resource "google_compute_instance" "spoke1_vm" {
  count                     = 2
  name                      = "${local.prefix}spoke1-vm${count.index + 1}"
  machine_type              = var.spoke_vm_type
  zone                      = data.google_compute_zones.main.names[0]
  can_ip_forward            = false
  allow_stopping_for_update = true

  metadata = {
    serial-port-enable = true
    ssh-keys           = fileexists(var.public_key_path) ? "${var.spoke_vm_user}:${file(var.public_key_path)}" : ""
  }

  network_interface {
    subnetwork = module.vpc_spoke1.subnets_self_links[0]
    #network_ip = cidrhost(var.cidr_spoke1, 10)
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


resource "google_compute_instance_group" "spoke1_ig" {
  name = "${local.prefix}spoke1-ig"
  zone = data.google_compute_zones.main.names[0]

  instances = google_compute_instance.spoke1_vm.*.id
}

module "spoke1_ilb" {
  source = "PaloAltoNetworks/vmseries-modules/google//modules/lb_internal"

  name       = "${local.prefix}spoke1-ilb"
  backends   = { 0 = google_compute_instance_group.spoke1_ig.self_link }
  ip_address = cidrhost(var.cidr_spoke1, 10)
  subnetwork = module.vpc_spoke1.subnets_self_links[0]
  network    = module.vpc_spoke1.network_id

  all_ports = false

  timeout_sec       = 1
  ports             = [80]
  health_check_port = 80

}
