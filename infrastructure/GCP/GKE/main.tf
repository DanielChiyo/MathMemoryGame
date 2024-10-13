
module "gke-autopilot" {
  source   = "./modules/Autopilot"
  region = var.region
}


/*
module "gke-standard" {
  source = "./modules/Standard"
  region = "us-central1"

  #If you specify a zone (such as us-central1-a), the cluster will be zonal
  #If you specify a region (such as us-west1), the cluster will be regional
  cluster_location = "us-central1-a"
  cluster_name     = "cluster-1"
  use_spot_vms     = true
  machine_type     = "e2-medium"
  gke_num_nodes    = 3
}
*/