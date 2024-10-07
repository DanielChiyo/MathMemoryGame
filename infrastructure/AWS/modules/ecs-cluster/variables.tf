variable name {
  type        = string
  default     = ""
  description = "The id of the vpc used in the cluster"
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

variable asg_subnet_ids {
    type        = list
    default     = []
    description = "Subnet ids for ASG usage"
}

variable ecs_cluster_name {
  type        = string
  description = "Name prefix for the ecs cluster"
  nullable = false
}

variable ecs_ami {
  type        = string
  description = "The ECS ami. Reference this link for to find https://docs.aws.amazon.com/pt_br/AmazonECS/latest/developerguide/launch_container_instance.html"
  nullable = false
}
