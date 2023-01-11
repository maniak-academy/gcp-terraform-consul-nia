
output "consul_server_external" {
  description = "External IP address of the consul server."
  value       = "http://${google_compute_address.consul_external_ip.address}:8500"

}
output "ssh_to_spoke2" {
  value = data.terraform_remote_state.environment.outputs.ssh_to_spoke2
}

output "ext_lb_url" {
  value = data.terraform_remote_state.environment.outputs.ext_lb_url
}