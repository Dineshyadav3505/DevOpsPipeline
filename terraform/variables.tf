variable "environment" {
  description = "The environment to deploy the infrastructure to"
  type = string
  default = "dev"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type = string
  default = "jenkins-vpc"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "azs" {
  description = "The availability zones to deploy the infrastructure to"
  type = list(string)
  default = ["ap-south-1a"]
}

variable "private_subnets" {
  description = "The private subnets to deploy the infrastructure to"
  type = list(string)
  default = ["10.0.1.0/24"]
}

variable "public_subnets" {
  description = "The public subnets to deploy the infrastructure to"
  type = list(string)
  default = ["10.0.101.0/24"]
}

variable "enable_nat_gateway" {
  description = "Whether to enable the NAT gateway"
  type = bool
  default = true
}

variable "region" {
  description = "The region to deploy the infrastructure to"
  type = string
  default = "ap-south-1"
}

variable "instance_size" {
  description = "The size of the AWS instance"
  type = number
  default = 10
  
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type = string
  default = "jenkins-vpc-s3-bucket"
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  type = string
  default = "jenkins-vpc-dynamodb-table"
}

variable "dynamodb_table_hash_key" {
  description = "The hash key of the DynamoDB table"
  type = string
  default = "id"
}

variable "dynamodb_table_attribute_name" {
  description = "The attribute name of the DynamoDB table"
  type = string
  default = "id"
}

variable "dynamodb_table_attribute_type" {
  description = "The attribute type of the DynamoDB table"
  type = string
  default = "N"
}

