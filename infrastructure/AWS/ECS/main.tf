locals {
  region               = "us-east-2"
  public_subnet_cidrs  = ["10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.4.0/24"]
  azs                  = slice(data.aws_availability_zones.available.names, 0, length(local.public_subnet_cidrs))
  project_name         = "Test-project"
  environment          = "Development"
  #implemented like this because there is no name in atribute reference
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers
  ecs_capacity_provider_name = "test1" 
}

data "aws_availability_zones" "available" {}

#data source not in use
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
  project_name         = local.project_name
  environment          = local.environment
  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
  azs                  = local.azs
}
#name = format("master-%s.masters.%s", var.zone, var.cluster_name)

module "ecs-ec2" {
  source           = "../modules/ecs-cluster"
  ecs_cluster_name = "MyECSCluster"
  project_name     = local.project_name
  environment      = local.environment
  vpc_id           = module.my-vpc.vpc_id
  asg_subnet_ids   = module.my-vpc.public_subnets_ids
  ecs_ami          = data.aws_ami.ecs_ami.id #https://docs.aws.amazon.com/pt_br/AmazonECS/latest/developerguide/launch_container_instance.html
  ecs_capacity_provider_name = local.ecs_capacity_provider_name
}

data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/arm64/recommended/image_id"
}

module "ecs-service" {
  source                     = "../modules/ecs-service"
  subnet_ids                 = module.my-vpc.public_subnets_ids
  vpc_id                     = module.my-vpc.vpc_id
  project_name               = local.project_name
  environment                = local.environment
  ecs_cluster_id             = module.ecs-ec2.ecs_cluster_id
  ecs_capacity_provider_name = local.ecs_capacity_provider_name
}
