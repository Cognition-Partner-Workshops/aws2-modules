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

module "payments_db" {
  source              = "../../modules/rds-postgres"
  db_identifier       = "payments-example"
  database_name       = "payments"
  master_username     = "payments_admin"
  kms_key_arn         = "arn:aws:kms:us-east-1:111111111111:key/example"
  vpc_id              = "vpc-0123456789abcdef0"
  subnet_ids          = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]
  allowed_cidr_blocks = ["10.20.0.0/16"]
  tags = {
    app                 = "payments"
    owner               = "payments-platform"
    data_classification = "restricted"
    cost_center         = "cc-4100"
  }
}
