variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

variable use_spot_vms {
  type        = bool
  default     = false
  description = "If set to false uses ondemand. Default is false"
}

variable machine_type {
  type        = string
  default     = "n1-standard-1"
  description = "Node pool machine type"
}

variable cluster_name {
  type        = string
  default     = "cluster-1"
  description = "GKE cluster name"
}

variable region {
  type        = string
  default     = "us-central1"
  description = "VPC Region"
}

variable cluster_location {
  type        = string
  default     = "us-central1-a"
  description = "description"
}

variable version_prefix {
  type        = string
  default     = "1.30."
  description = "Kubernetes version prefix"
}
