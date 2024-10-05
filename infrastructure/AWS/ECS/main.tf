locals {
    region = "us-east-2"
    public_subnet_cidrs = ["10.0.1.0/24"]
    private_subnet_cidrs =["10.0.4.0/24"]
    azs = slice(data.aws_availability_zones.available.names, 0, length(local.public_subnet_cidrs))
}

data "aws_availability_zones" "available" {}

module "my-vpc" {
  source               = "../modules/simple-vpc"
  project_name         = "Test-project"
  environment          = "Development"
  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
  azs = local.azs
}
#name = format("master-%s.masters.%s", var.zone, var.cluster_name)