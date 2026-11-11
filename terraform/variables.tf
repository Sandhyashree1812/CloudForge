variable "aws_region" {
  description = "AWS region for CloudForge infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "CloudForge project name"
  type        = string
  default     = "cloudforge"
}

variable "vpc_cidr" {
  description = "CIDR block for CloudForge VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for CloudForge public subnet"
  type        = string
  default     = "10.0.1.0/24"
}