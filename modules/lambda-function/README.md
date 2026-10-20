# Lambda function

Creates a function using a caller-managed execution role, KMS-encrypted environment and logs, active X-Ray tracing, a required dead-letter destination, and optional reserved concurrency, VPC access, and code-signing enforcement.

Required inputs: `function_name`, `role_arn`, `kms_key_arn`, `filename`, `source_code_hash`, `handler`, `failure_destination_arn`, `tags`.

Optional inputs: `runtime`, `timeout`, `memory_size`, `reserved_concurrent_executions`, `environment_variables`, `vpc_subnet_ids`, `vpc_security_group_ids`, `log_retention_days`, `signing_profile_version_arns`, `signing_config_description`.
