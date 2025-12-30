
# output "cluster_name" {
#   description = "Name of the EKS cluster (with unique suffix)"
#   value       = module.vpc.name
# }

# output "vpc_id" {
#   description = "The ID of the VPC"
#   value       = module.vpc.vpc_id
# }

# output "vpc_cidr" {
#   description = "The CIDR block of the VPC"
#   value       = module.vpc.vpc_cidr_block
# }

# output "vpc_availability_zones" {
#   description = "The availability zones of the VPC"
#   value       = module.vpc.azs

# }

# output "jenkins_public_route_table" {
#   description = "The public route table ID"
#   value       = aws_route_table.jenkins_public_route_table.id
# }

# output "jenkins_private_route_table" {
#   description = "The private route table ID"
#   value       = aws_route_table.jenkins_private_route_table.id
# }

# output "public_subnets" {
#   description = "The public subnets IDs"
#   value       = module.vpc.public_subnets
# }

# output "public_subnet_instances" {
#   description = "The public subnet instances"
#   value       = [for k, v in aws_instance.jenkins_public_instance : v.id]
# }

# output "private_subnets" {
#   description = "The private subnets IDs"
#   value       = module.vpc.private_subnets
# }

# output "private_subnet_instances" {
#   description = "The private subnet instances"
#   value       = [for k, v in aws_instance.jenkins_private_instance : v.id]
# }
