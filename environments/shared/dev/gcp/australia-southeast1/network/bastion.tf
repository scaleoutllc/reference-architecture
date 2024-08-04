data "google_compute_zones" "available" {}

resource "google_compute_firewall" "ssh-rule" {
  name    = "${local.name}-bastion-ssh"
  network = data.google_compute_network.this.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags   = ["bastion-vm"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "bastion" {
  name         = "bastion"
  machine_type = "n2-standard-2"
  zone         = data.google_compute_zones.available.names[0]
  network_interface {
    subnetwork = google_compute_subnetwork.main.self_link
    access_config {}
  }
  boot_disk {
    initialize_params {
      image = "ubuntu-2404-noble-amd64-v20240717"
    }
  }
  metadata = {
    ssh-keys       = <<EOF
      root:${file(pathexpand("~/.ssh/id_rsa.pub"))} root
    EOF
    startup-script = "#!/bin/bash\nsudo apt-get update && sudo apt-get install netcat-openbsd -y"
  }
  tags = ["bastion-vm"]
}

output "bastion-ssh" {
  value = "root@${google_compute_instance.bastion.network_interface.0.access_config.0.nat_ip}"
}

output "bastion-ip" {
  value = google_compute_instance.bastion.network_interface.0.network_ip
}
