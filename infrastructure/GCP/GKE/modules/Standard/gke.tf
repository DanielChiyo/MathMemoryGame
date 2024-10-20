# GKE cluster
data "google_container_engine_versions" "gke_version" {
  location = var.region
  version_prefix = var.version_prefix
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.cluster_location

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  node_config {
    machine_type = "n1-standard-1"  # You can try a different or smaller machine type here
    disk_type    = "pd-standard"
    disk_size_gb = 20
  }

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  deletion_protection = false

  # Add lifecycle block to ignore changes to tags
  lifecycle {
    ignore_changes = [
      node_config  
      #Since default node pool will be deleted we ignore changes on it.
      #Other wise it would compare to the managed node pool
      #And trigger unwanted/unnecessary changes or even replacements
    ]
  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "managed-node-pool"
  location   = var.cluster_location
  cluster    = google_container_cluster.primary.name
  
  version = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    
    labels = {
      cluster = var.cluster_name
    }

    spot  = var.use_spot_vms
    machine_type = var.machine_type
    disk_type = "pd-standard"
    disk_size_gb =  20
    tags         = ["gke-node", "${var.cluster_name}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  lifecycle {
    ignore_changes = [
      version #Keeping the cluster from automatic version upgrades
    ]
  }
}