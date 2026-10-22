terraform {
  required_version = ">= 1.6"
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

module "wire_records" {
  source                     = "../../modules/s3-bucket"
  bucket_name                = "bank-wire-records-example"
  kms_key_arn                = "arn:aws:kms:us-east-1:111111111111:key/example"
  access_log_bucket          = "bank-access-logs-example"
  logging_source_bucket_arns = ["arn:aws:s3:::bank-wire-records-example"]
  logging_target_prefix      = "wire-records/"
  object_lock_enabled        = true
  object_lock_default_retention = {
    mode = "COMPLIANCE"
    days = 2555
  }
  lifecycle_rules = [
    {
      id                                 = "retain-wire-records"
      expiration_days                    = 2555
      noncurrent_version_expiration_days = 2555
    },
    {
      id                                  = "archive-noncurrent"
      noncurrent_transition_days          = 365
      noncurrent_transition_storage_class = "GLACIER"
    },
  ]
  tags = {
    app                 = "wire-archive"
    owner               = "payments-platform"
    data_classification = "restricted"
    cost_center         = "cc-4100"
  }
}

output "object_lock_enabled" {
  value = module.wire_records.object_lock_enabled
}
