variable "role_name" {
  type        = string
  description = "Name of the workload role."
}

variable "permissions_boundary_arn" {
  type        = string
  description = "Required permissions boundary ARN."
}

variable "assume_role_principals" {
  type        = list(string)
  description = "AWS principals permitted to assume this role."
}

variable "assume_role_principal_type" {
  type        = string
  description = "Principal type used in the role trust policy."
  default     = "Service"
  validation {
    condition     = contains(["AWS", "Service"], var.assume_role_principal_type)
    error_message = "assume_role_principal_type must be AWS or Service."
  }
}

variable "inline_policy_statements" {
  type = list(object({
    sid       = optional(string)
    effect    = optional(string, "Allow")
    actions   = list(string)
    resources = list(string)
  }))
  description = "Least-privilege inline policy statements."
  default     = []
  validation {
    condition     = alltrue(flatten([for statement in var.inline_policy_statements : [for action in statement.actions : action != "*"]]))
    error_message = "Inline policies cannot grant the wildcard action '*'."
  }
}

variable "inline_policy_name" {
  type        = string
  description = "Optional name for the inline policy."
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
