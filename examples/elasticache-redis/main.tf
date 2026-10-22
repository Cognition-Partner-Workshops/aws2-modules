terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
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

module "payments_cache" {
  source                     = "../../modules/elasticache-redis"
  replication_group_id       = "payments-cache-example"
  description                = "Payments API session and idempotency cache"
  kms_key_arn                = "arn:aws:kms:us-east-1:111111111111:key/example"
  vpc_id                     = "vpc-0123456789abcdef0"
  subnet_ids                 = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]
  ingress_security_group_ids = ["sg-0123456789abcdef0"]
  tags = {
    app                 = "payments"
    owner               = "payments-platform"
    data_classification = "restricted"
    cost_center         = "cc-4100"
  }
}
