locals {
  region               = "us-east-2"
  public_subnet_cidrs  = ["10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.4.0/24"]
  azs                  = slice(data.aws_availability_zones.available.names, 0, length(local.public_subnet_cidrs))
}

data "aws_availability_zones" "available" {}

data "aws_ami" "ecs_ami" {
  most_recent = true

  owners = ["amazon"] # Specify the owner as Amazon

  filter {
    name   = "name"
    values = ["al2023-ami-ecs-hvm-*"] # Use a wildcard to match the AMI name pattern
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"] # Ensure you're using HVM virtualization
  }

  filter {
    name   = "architecture"
    values = ["arm64"] # Specify ARM architecture
  }
}

module "my-vpc" {
  source               = "../modules/simple-vpc"
  project_name         = "Test-project"
  environment          = "Development"
  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
  azs                  = local.azs
}
#name = format("master-%s.masters.%s", var.zone, var.cluster_name)

module "ecs-ec2" {
  source       = "../modules/ecs-cluster"
  ecs_cluster_name = "MyECSCluster"
  project_name = "Test-project"
  environment  = "Development"
  vpc_id       = module.my-vpc.vpc_id
  asg_subnet_ids = module.my-vpc.public_subnets_ids
  ecs_ami = data.aws_ami.ecs_ami.id #https://docs.aws.amazon.com/pt_br/AmazonECS/latest/developerguide/launch_container_instance.html
}




data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/arm64/recommended/image_id"
}

output ssm {
  value       = data.aws_ssm_parameter.ecs_ami
  sensitive   = false
  description = "description"
}
