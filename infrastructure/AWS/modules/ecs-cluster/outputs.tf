output ecs_cluster_id {
  value       = aws_ecs_cluster.ecs_cluster.id
  sensitive   = false
  description = "The name of the ECS cluster"
}

output ecs_ec2_capacity_provider_name {
  value       = aws_ecs_cluster_capacity_providers.example.id
  sensitive   = false
  description = "The id of the ECS cluster"
}
