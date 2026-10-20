variable "key_description" {
  type        = string
  description = "Description recorded for this KMS key."
}

variable "alias_name" {
  type        = string
  description = "Alias name, with or without the alias/ prefix."
}

variable "account_id" {
  type        = string
  description = "AWS account ID whose root principal administers the key."
}

variable "admin_role_arns" {
  type        = list(string)
  description = "IAM roles allowed to administer the key."
}

variable "user_role_arns" {
  type        = list(string)
  description = "IAM roles allowed to use the key for data cryptographic operations."
  default     = []
}

variable "service_principals" {
  type        = list(string)
  description = "AWS service principals allowed to use the key for data cryptographic operations."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Resource tags including app, owner, data_classification, and cost_center."
  validation {
    condition     = alltrue([for key in ["app", "owner", "data_classification", "cost_center"] : contains(keys(var.tags), key)])
    error_message = "tags must include app, owner, data_classification, and cost_center."
  }
}
