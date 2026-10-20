variable "db_identifier" {
  type        = string
  description = "Unique database instance identifier."
}

variable "database_name" {
  type        = string
  description = "Initial database name."
}

variable "master_username" {
  type        = string
  description = "Master database username; the password is managed by RDS."
}

variable "kms_key_arn" {
  type        = string
  description = "Customer-managed KMS key for database and Performance Insights encryption."
}

variable "vpc_id" {
  type        = string
  description = "VPC hosting the database."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the database subnet group."
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "Network ranges permitted to connect to PostgreSQL."
}

variable "subnet_group_name" {
  type        = string
  description = "Optional name for the database subnet group."
  default     = null
}

variable "security_group_name" {
  type        = string
  description = "Optional name for the database security group."
  default     = null
}

variable "parameter_group_name" {
  type        = string
  description = "Optional name for the database parameter group."
  default     = null
}

variable "monitoring_role_name" {
  type        = string
  description = "Optional name for the enhanced monitoring role."
  default     = null
}

variable "backup_retention_days" {
  type        = number
  description = "Automated backup retention in days; minimum is 14."
  default     = 14
  validation {
    condition     = var.backup_retention_days >= 14
    error_message = "backup_retention_days must be at least 14."
  }
}

variable "instance_class" {
  type        = string
  description = "RDS instance class."
  default     = "db.m6g.large"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags including app, owner, data_classification, and cost_center."
  validation {
    condition     = alltrue([for key in ["app", "owner", "data_classification", "cost_center"] : contains(keys(var.tags), key)])
    error_message = "tags must include app, owner, data_classification, and cost_center."
  }
}
