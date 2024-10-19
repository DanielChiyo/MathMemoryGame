
/*
module "gke-autopilot" {
  source   = "./modules/Autopilot"
  region = var.region
}
*/

module "gke-standard" {
  source = "./modules/Standard"
  region = "us-central1"

  #If you specify a zone (such as us-central1-a), the cluster will be zonal
  #If you specify a region (such as us-west1), the cluster will be regional
  cluster_location = "us-central1-a"
  cluster_name     = "cluster-1"
  use_spot_vms     = true
  machine_type     = "e2-standard-4"
  gke_num_nodes    = 2
}

provider "kubernetes" {
  host                   = module.gke-standard.host
  token                  = module.gke-standard.token
  cluster_ca_certificate = module.gke-standard.cluster_ca_certificate

  ignore_annotations = [
    "^autopilot\\.gke\\.io\\/.*",
    "^cloud\\.google\\.com\\/.*"
  ]
}

provider "helm" {
    kubernetes{
        host                   = module.gke-standard.host
        token                  = module.gke-standard.token
        cluster_ca_certificate = module.gke-standard.cluster_ca_certificate
        exec {
            api_version = "client.authentication.k8s.io/v1beta1"
            command     = "gke-gcloud-auth-plugin"
        }
    }
}

module "argocd" {
  source = "../../Kubernetes/ArgoCD"
  depends_on = [module.gke-standard]
}