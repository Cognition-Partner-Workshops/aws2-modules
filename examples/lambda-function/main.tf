terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
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

data "archive_file" "function" {
  type        = "zip"
  source_file = "${path.module}/handler.py"
  output_path = "${path.module}/function.zip"
}

module "report_generator" {
  source                         = "../../modules/lambda-function"
  function_name                  = "report-generator-example"
  role_arn                       = "arn:aws:iam::111111111111:role/report-generator"
  kms_key_arn                    = "arn:aws:kms:us-east-1:111111111111:key/example"
  filename                       = data.archive_file.function.output_path
  source_code_hash               = data.archive_file.function.output_base64sha256
  handler                        = "handler.handler"
  failure_destination_arn        = "arn:aws:sqs:us-east-1:111111111111:report-generator-dlq"
  reserved_concurrent_executions = 10
  vpc_subnet_ids                 = ["subnet-11111111", "subnet-22222222"]
  vpc_security_group_ids         = ["sg-11111111"]
  signing_profile_version_arns   = ["arn:aws:signer:us-east-1:111111111111:/signing-profiles/report-generator/version/11111111-2222-3333-4444-555555555555"]
  tags = {
    app                 = "reporting"
    owner               = "payments-platform"
    data_classification = "confidential"
    cost_center         = "cc-4100"
  }
}
