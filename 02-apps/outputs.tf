
output "consul_server_external" {
  description = "External IP address of the consul server."
  value       = "http://${google_compute_address.consul_external_ip.address}:8500"

}
output "ssh_to_spoke2" {
  value = data.terraform_remote_state.environment.outputs.ssh_to_spoke2
}

output "ext_lb_url" {
  description = "External App."
  value = data.terraform_remote_state.environment.outputs.ext_lb_url
}

output "vmseries01_access" {
  description = "Management URL for vmseries01."
  value = "https://${data.terraform_remote_state.environment.outputs.vmseries01_access}"
}

# output "vmseries02_access" {
#   description = "Management URL for vmseries02."
#   value = "https://${data.terraform_remote_state.environment.outputs.vmseries02_access}"
# }

# output "vault_server_external" {
#   value = data.terraform_remote_state.environment.outputs.vault_server_external
# }