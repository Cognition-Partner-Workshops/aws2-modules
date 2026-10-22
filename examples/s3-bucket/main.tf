terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "mock"
  secret_key                  = "mock"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
}

module "archive" {
  source                     = "../../modules/s3-bucket"
  bucket_name                = "bank-archive-example"
  kms_key_arn                = "arn:aws:kms:us-east-1:111111111111:key/example"
  access_log_bucket          = "bank-access-logs-example"
  logging_source_bucket_arns = ["arn:aws:s3:::bank-archive-example"]
  lifecycle_rules = [{
    id                                  = "archive-object-versions"
    current_transition_days             = 30
    current_transition_storage_class    = "STANDARD_IA"
    noncurrent_transition_days          = 60
    noncurrent_transition_storage_class = "GLACIER"
    noncurrent_version_expiration_days  = 365
  }]
  tags = {
    app                 = "archive"
    owner               = "platform-security"
    data_classification = "confidential"
    cost_center         = "cc-4100"
  }
}
