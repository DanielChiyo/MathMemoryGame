terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.70.0"
    }
  }
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

provider "aws" {
  region     = local.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}