output "ext_lb_url" {
  description = "External load balancer's frontend URL that resolves to spoke1 web servers after VM-Series inspection."
  value       = "http://${module.lb_external.ip_addresses["rule1"]}"
}

output "ssh_to_spoke2" {
  description = "External load balancer's frontend address that opens SSH session to spoke2-vm1 after VM-Series inspection."
  value       = "ssh ${var.spoke_vm_user}@${module.lb_external.ip_addresses["rule2"]}"
}

output "vmseries01_access" {
  description = "Management URL for vmseries01."
  value       = module.vmseries["vmseries01"].public_ips[1]
}

# output "consul_server_external" {
#   description = "External IP address of the consul server."
#   value       = "https//${google_compute_address.consul_external_ip.address}:8500"

# }

# output "vmseries02_access" {
#   description = "Management URL for vmseries02."
#   value       = "${module.vmseries["vmseries02"].public_ips[1]}"
# }


output "region" {
  description = "GCloud Region"
  value       = var.region
}

output "project_id" {
  description = "GCloud Project ID"
  value       = var.project_id
}


# output "kubernetes_cluster_name" {
#   value       = google_container_cluster.primary.name
#   description = "GKE Cluster Name"
# }

# output "kubernetes_cluster_host" {
#   value       = google_container_cluster.primary.endpoint
#   description = "GKE Cluster Host"
# }
# output "region" {
#   value       = var.region
#   description = "GCloud Region"
# }

output "spoke_vm_user" {
  description = "Spoke VM User"
  value       = var.spoke_vm_user
}
output "spoke_vm_type" {
  description = "Spoke VM Type"
  value       = var.spoke_vm_type
}

output "spoke_vm_type2" {
  description = "Spoke VM Type"
  value       = var.spoke_vm_type2
}


output "google_compute_zones" {
  value = data.google_compute_zones.main.names[0]
}

output "ss_subnets_self_links0" {
  value = module.vpc_ss.subnets_self_links[0]
}

output "spoke_vm_image" {
  description = "Spoke VM Image"
  value       = var.spoke_vm_image
}

output "spoke_vm_scopes" {
  description = "Spoke VM scopes"
  value       = var.spoke_vm_scopes
}

output "vpc_spoke1_network_id" {
  value = module.vpc_spoke1.network_id
}

# output "vault_server_external" {
#   description = "External IP address of the vault server."
#   value       = "http://${google_compute_address.vault_external_ip.address}:8200"
# }

output "username" {
  value = "paloalto"
}

output "password" {
  value = "Pal0Alt0@123"
}
