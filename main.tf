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
