resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_arn
  tags              = var.tags
}

resource "aws_lambda_function" "this" {
  function_name                  = var.function_name
  role                           = var.role_arn
  filename                       = var.filename
  source_code_hash               = var.source_code_hash
  handler                        = var.handler
  runtime                        = var.runtime
  timeout                        = var.timeout
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  kms_key_arn                    = var.kms_key_arn
  code_signing_config_arn        = length(var.signing_profile_version_arns) > 0 ? aws_lambda_code_signing_config.this[0].arn : null
  publish                        = true
  tags                           = var.tags

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = var.environment_variables
  }

  dynamic "vpc_config" {
    for_each = length(var.vpc_subnet_ids) > 0 ? [true] : []
    content {
      subnet_ids         = var.vpc_subnet_ids
      security_group_ids = var.vpc_security_group_ids
    }
  }

  dead_letter_config {
    target_arn = var.failure_destination_arn
  }

  lifecycle {
    precondition {
      condition = (
        length(var.vpc_subnet_ids) == 0 && length(var.vpc_security_group_ids) == 0
        || length(var.vpc_subnet_ids) > 0 && length(var.vpc_security_group_ids) > 0
      )
      error_message = "vpc_subnet_ids and vpc_security_group_ids must both be empty or both be nonempty."
    }
  }

  depends_on = [aws_cloudwatch_log_group.this]
}

resource "aws_lambda_code_signing_config" "this" {
  count = length(var.signing_profile_version_arns) > 0 ? 1 : 0
  allowed_publishers {
    signing_profile_version_arns = var.signing_profile_version_arns
  }
  policies {
    untrusted_artifact_on_deployment = "Enforce"
  }
  description = var.signing_config_description == null ? "Approved publishers for ${var.function_name}" : var.signing_config_description
}
