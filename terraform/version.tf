terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "jenkins-vpc-s3-bucket"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "jenkins-vpc-dynamodb-table"
  }
}

provider "aws" {
  region = "ap-south-1"
}
