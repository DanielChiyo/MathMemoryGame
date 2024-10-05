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

variable vpc_cidr {
  type        = string
  default     = "10.0.0.0/16"
  description = "Cidr block used for VPC"
}

variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
 
variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}