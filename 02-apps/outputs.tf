
output "consul_server_external" {
  description = "External IP address of the consul server."
  value       = "https://${google_compute_address.consul_external_ip.address}:8500"

}
