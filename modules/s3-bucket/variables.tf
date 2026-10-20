variable "bucket_name" {
  type        = string
  description = "Globally unique bucket name."
}

variable "kms_key_arn" {
  type        = string
  description = "Customer-managed KMS key used for server-side encryption."
}

variable "access_log_bucket" {
  type        = string
  description = "Bucket receiving S3 server access logs."
}

variable "log_bucket_mode" {
  type        = bool
  description = "Set true for a dedicated access-log bucket that must not log to itself."
  default     = false
}

variable "logging_source_bucket_arns" {
  type        = list(string)
  description = "Source bucket ARNs allowed to deliver logs when this is a log destination."
  default     = []
  validation {
    condition     = !var.log_bucket_mode || length(var.logging_source_bucket_arns) > 0
    error_message = "log_bucket_mode requires at least one logging_source_bucket_arns entry."
  }
}

variable "logging_target_prefix" {
  type        = string
  description = "Object prefix for server access logs; defaults to the bucket name."
  default     = null
}

variable "lifecycle_rules" {
  type = list(object({
    id                                  = string
    enabled                             = optional(bool, true)
    expiration_days                     = optional(number)
    noncurrent_version_expiration_days  = optional(number)
    current_transition_days             = optional(number)
    current_transition_storage_class    = optional(string)
    noncurrent_transition_days          = optional(number)
    noncurrent_transition_storage_class = optional(string)
  }))
  description = "Optional expiration and transition actions for current and noncurrent object versions."
  default     = []
  validation {
    condition = alltrue([
      for rule in var.lifecycle_rules :
      (rule.current_transition_days == null) == (rule.current_transition_storage_class == null)
      && (rule.noncurrent_transition_days == null) == (rule.noncurrent_transition_storage_class == null)
    ])
    error_message = "Each lifecycle transition requires both its day and storage-class values."
  }
}

variable "tags" {
  type        = map(string)
  description = "Resource tags including app, owner, data_classification, and cost_center."
  validation {
    condition     = alltrue([for key in ["app", "owner", "data_classification", "cost_center"] : contains(keys(var.tags), key)])
    error_message = "tags must include app, owner, data_classification, and cost_center."
  }
}
