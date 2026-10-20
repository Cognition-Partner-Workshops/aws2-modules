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

module "reporting_role" {
  source                     = "../../modules/iam-role"
  role_name                  = "reporting-worker"
  permissions_boundary_arn   = "arn:aws:iam::111111111111:policy/WorkloadBoundary"
  assume_role_principal_type = "AWS"
  assume_role_principals     = ["arn:aws:iam::111111111111:role/runtime"]
  inline_policy_statements = [{
    sid       = "WriteReports"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::bank-reports-example/*"]
  }]
  tags = {
    app                 = "reporting"
    owner               = "payments-platform"
    data_classification = "confidential"
    cost_center         = "cc-4100"
  }
}
