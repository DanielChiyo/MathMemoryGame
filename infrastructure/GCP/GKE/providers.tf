terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.6.0"
    }
  }
}

variable "project_id" {}
variable "region" {}

provider "google" {
  project = var.project_id
  region  = var.region
}