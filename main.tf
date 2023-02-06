provider "google" {
  version = "3.82.0"
  credentials = "kk-tf-account.json"
  project     = "kk-project-376920"
  region      = "us-west1"
  #zone        = "us-west1"

}

resource "google_compute_network" "vpc_network" {
  name                    = "kk-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "kk_subnet1" {
  name          = "kk-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-west1"
  network       = google_compute_network.vpc_network.id
}


# Create a single Compute Engine instance
resource "google_compute_instance" "kk_vm" {
  name         = "kk-vm-${count.index}"
  machine_type = "f1-micro"
  zone         = "us-west1-a"
  tags         = ["ssh"]
  count = "2"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # Install kk
  metadata_startup_script = "sudo apt-get update; sudo apt-get install httpd"

  network_interface {
    subnetwork = google_compute_subnetwork.kk_subnet1.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}
