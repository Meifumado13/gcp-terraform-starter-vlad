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
