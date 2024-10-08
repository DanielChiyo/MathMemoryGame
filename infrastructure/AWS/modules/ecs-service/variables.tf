variable subnet_ids {
    type        = list
    default     = []
    description = "Subnet ids for service usage"
}

variable environment {
  type        = string
  #default     = ""
  description = "The environment"
  #nullable = false
  validation {
    condition     = contains(["Development", "Homolog", "Production"], var.environment)
    error_message = "The environment must be one of Development, Homolog, or Production"
  }
}

variable project_name {
  type        = string
  #default     = ""
  description = "Name of the project"
}

variable vpc_id {
  type        = string
  default     = ""
  description = "VPC id for the ECS cluster SG"
}

variable ecs_cluster_id {
  type        = string
  default     = ""
  description = "The id of the ECS Cluster used for this service"
}

variable ecs_capacity_provider_name {
  type        = string
  default     = ""
  description = "The name of the ECS capacity provider to be used for this service"
}