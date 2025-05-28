output "network_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.vpc_network.name
}

output "vm_external_ip" {
  description = "External (NAT) IP address of the VM"
  value       = google_compute_instance.vlad_vm.network_interface[0].access_config[0].nat_ip
}

output "vm_internal_ip" {
  description = "Internal IP address of the VM"
  value       = google_compute_instance.vlad_vm.network_interface[0].network_ip
}
