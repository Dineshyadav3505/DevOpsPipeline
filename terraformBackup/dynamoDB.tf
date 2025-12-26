module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = var.dynamodb_table_hash_key

  attributes = [
    {
      name = var.dynamodb_table_attribute_name
      type = var.dynamodb_table_attribute_type
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}