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

module "data_key" {
  source             = "../../modules/kms-key"
  key_description    = "Application data key"
  alias_name         = "application/data"
  account_id         = "111111111111"
  admin_role_arns    = ["arn:aws:iam::111111111111:role/security-admin"]
  user_role_arns     = ["arn:aws:iam::111111111111:role/application"]
  service_principals = ["s3.amazonaws.com"]
  tags = {
    app                 = "application"
    owner               = "platform-security"
    data_classification = "confidential"
    cost_center         = "cc-4100"
  }
}
