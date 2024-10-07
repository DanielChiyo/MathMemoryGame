output vpc_id {
  value       = aws_vpc.my_vpc.id
  description = "The id of the vpc created by the module"
}

output public_subnets_ids {
  value       = aws_subnet.public_subnets[*].id
  description = "The created public_subnet_ids"
}
