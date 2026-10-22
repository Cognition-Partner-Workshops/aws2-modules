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

module "requests" {
  source      = "../../modules/sqs-queue"
  queue_name  = "report-requests"
  kms_key_arn = "arn:aws:kms:us-east-1:111111111111:key/example"
  tags = {
    app                 = "reporting"
    owner               = "payments-platform"
    data_classification = "confidential"
    cost_center         = "cc-4100"
  }
}
