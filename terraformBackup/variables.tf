variable "environment" {
  description = "The environment to deploy the infrastructure to"
  type = string
  default = "dev"
}

variable "region" {
  description = "The region to deploy the infrastructure to"
  type = string
  default = "ap-south-1"
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
  default = "LockID"
}

variable "dynamodb_table_attribute_name" {
  description = "The attribute name of the DynamoDB table"
  type = string
  default = "LockID"
}

variable "dynamodb_table_attribute_type" {
  description = "The attribute type of the DynamoDB table"
  type = string
  default = "S"
}
