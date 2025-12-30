output "cluster_name" {
  description = "Name of the EKS cluster (with unique suffix)"
  value       = module.vpc.name
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "vpc_availability_zones" {
  description = "The availability zones of the VPC"
  value       = module.vpc.azs
}

output "ec2_instance_public_ips" {
  description = "A map of instance names to their public IPs"
  value       = { for instance in aws_instance.jenkins_public_instance : instance.tags.Name => instance.public_ip }
}

output "ec2_instance_private_ips" {
  description = "A map of instance names to their public IPs"
  value       = { for instance in aws_instance.jenkins_private_instance : instance.tags.Name => instance.private_ip }
}
