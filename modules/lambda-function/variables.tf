variable "function_name" {
  type        = string
  description = "Name of the Lambda function."
}

variable "role_arn" {
  type        = string
  description = "Execution role ARN; this module does not create the role."
}

variable "kms_key_arn" {
  type        = string
  description = "KMS key ARN for environment variables and the log group."
}

variable "filename" {
  type        = string
  description = "Path to the packaged Lambda deployment archive."
}

variable "source_code_hash" {
  type        = string
  description = "Base64-encoded source archive hash."
}

variable "handler" {
  type        = string
  description = "Function handler entry point."
}

variable "failure_destination_arn" {
  type        = string
  description = "SQS or SNS dead-letter queue ARN for failed invocations."
}

variable "runtime" {
  type        = string
  description = "Lambda runtime."
  default     = "python3.12"
}

variable "timeout" {
  type        = number
  description = "Maximum execution time in seconds."
  default     = 30
}

variable "memory_size" {
  type        = number
  description = "Memory allocated to the function in MB."
  default     = 256
}

variable "reserved_concurrent_executions" {
  type        = number
  description = "Optional reserved concurrency limit."
  default     = null
}

variable "environment_variables" {
  type        = map(string)
  description = "Optional environment variables."
  default     = {}
}

variable "vpc_subnet_ids" {
  type        = list(string)
  description = "Optional private subnet IDs for functions that access VPC resources."
  default     = []
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "Security groups used when VPC subnets are configured."
  default     = []
}

variable "log_retention_days" {
  type        = number
  description = "CloudWatch log retention period."
  default     = 365
}

variable "signing_profile_version_arns" {
  type        = list(string)
  description = "Optional signing profile version ARNs that may publish code."
  default     = []
}

variable "signing_config_description" {
  type        = string
  description = "Optional description for the code-signing configuration."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Resource tags including app, owner, data_classification, and cost_center."
  validation {
    condition     = alltrue([for key in ["app", "owner", "data_classification", "cost_center"] : contains(keys(var.tags), key)])
    error_message = "tags must include app, owner, data_classification, and cost_center."
  }
}
