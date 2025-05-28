# Created on May 24, 2025 — vlad-vpc deployed to GCP via Terraform.

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name                    = "vlad-vpc"
  auto_create_subnetworks = true
}
resource "google_compute_subnetwork" "vlad_subnet" {
  name          = "vlad-subnet"
  ip_cidr_range = "10.13.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}
resource "google_compute_firewall" "vlad_allow_ssh" {
  name    = "vlad-allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["ssh-access"]
}
resource "google_compute_firewall" "vlad_allow_http" {
  name    = "vlad-allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["http-server"]
}
resource "google_compute_instance" "vlad_vm" {
  name         = "vlad-vm"
  machine_type = "e2-micro"
  zone         = var.zone

  tags = ["ssh-access"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vlad_subnet.name

    access_config {
      # Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys = "vlad:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDln66KwM/GSf7bFcgakN+lxPW6s3dmUsY6l5wqEFod1e8W4S6t81Z0Sj0IcRqf9pJLuv4VGaW3iy+zFtS9v7BCvZuwexCHPSgnBq2LXL0wZr+DSC6qDnsqoQH4/iGk8Q/rbXlf5CpftVwv6PSPgNR1q4rk3R2vcsRB/O2euN9xRYLY9P2XEvqoa6/zkVsbSdtoZk3acls27w6VM2DxySeR8wLexrcWqfoI7HyQQVQ20V8yubAkiJ6eNKG0/sqR9s8i4ALex8GAXKUnNKHvdMRNEOM6aFwzvr1Um1M2Eakhy5/Mu5hMs8orRn73op/6m37ek3WoM144FBOkGz3Y+pD8iB5vA2q3CkU2JmtsoUgqh97MDxKnFKeWgQ/LVB0K5zAgyVINdWpgAc8R4ChtDDJZEogq0dFIuVieFdonoBoF4CeVIZt2V0AZwQH9y+fEkLZaVJDv0vyFnTG4WETzlYNiX4jCl7yBPO0Zjrpy4Lmne0w+v/dBisFhF9vVcGH4o4rhn1KuV7Xo1KSIFbCjL5AUL5ylZDR7AVMmFzrcIMaWFeW3ZWvFxiBE68vsO1tT5toHLlOFzsqglaao/9OTcHgMDKExEWVQ6SbKG7j5WdhnZXk7rviEIKRyU4vIZCpn7eKIhWZ00Do6r2XUFl/Oo+a+mYfqkgcArFK4SA77ttNzEw== vlad.w.narcisse@gmail.com"
  }
}
