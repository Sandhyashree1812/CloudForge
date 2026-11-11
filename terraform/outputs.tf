output "vpc_id" {
  description = "CloudForge VPC ID"
  value       = aws_vpc.cloudforge.id
}

output "public_subnet_id" {
  description = "CloudForge public subnet ID"
  value       = aws_subnet.public.id
}

output "internet_gateway_id" {
  description = "CloudForge internet gateway ID"
  value       = aws_internet_gateway.cloudforge.id
}

output "aws_region" {
  description = "AWS deployment region"
  value       = var.aws_region
}