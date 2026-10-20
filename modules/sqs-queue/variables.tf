variable "queue_name" {
  type        = string
  description = "Name of the processing queue."
}

variable "kms_key_arn" {
  type        = string
  description = "Customer-managed KMS key used for both queues."
}

variable "max_receive_count" {
  type        = number
  description = "Receives before a message is moved to the dead-letter queue."
  default     = 5
  validation {
    condition     = var.max_receive_count >= 1
    error_message = "max_receive_count must be at least 1."
  }
}

variable "retention_seconds" {
  type        = number
  description = "Message retention period for both queues."
  default     = 1209600
}

variable "tags" {
  type        = map(string)
  description = "Resource tags including app, owner, data_classification, and cost_center."
  validation {
    condition     = alltrue([for key in ["app", "owner", "data_classification", "cost_center"] : contains(keys(var.tags), key)])
    error_message = "tags must include app, owner, data_classification, and cost_center."
  }
}
