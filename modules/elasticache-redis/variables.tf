variable "replication_group_id" {
  type        = string
  description = "Unique replication group identifier."
}

variable "description" {
  type        = string
  description = "Human-readable purpose of the replication group."
}

variable "kms_key_arn" {
  type        = string
  description = "Customer-managed KMS key for at-rest encryption."
}

variable "vpc_id" {
  type        = string
  description = "VPC hosting the cache."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the cache subnet group."
}

variable "ingress_security_group_ids" {
  type        = list(string)
  description = "Security groups permitted to connect to Redis. At least one of ingress_security_group_ids or allowed_cidr_blocks is required."
  default     = []
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "Network ranges permitted to connect to Redis; 0.0.0.0/0 and ::/0 are rejected."
  default     = []
  validation {
    condition     = alltrue([for cidr in var.allowed_cidr_blocks : !contains(["0.0.0.0/0", "::/0"], cidr)])
    error_message = "allowed_cidr_blocks must not contain 0.0.0.0/0 or ::/0."
  }
}

variable "node_type" {
  type        = string
  description = "Cache node instance type."
  default     = "cache.t4g.small"
}

variable "engine_version" {
  type        = string
  description = "Redis engine version."
  default     = "7.1"
}

variable "num_cache_clusters" {
  type        = number
  description = "Number of cache clusters (primary plus replicas); minimum is 2 for automatic failover."
  default     = 2
  validation {
    condition     = var.num_cache_clusters >= 2
    error_message = "num_cache_clusters must be at least 2 so automatic failover and Multi-AZ can be enabled."
  }
}

variable "port" {
  type        = number
  description = "Port the cache accepts connections on."
  default     = 6379
}

variable "parameter_group_name" {
  type        = string
  description = "Optional ElastiCache parameter group; the engine default is used when null."
  default     = null
}

variable "maintenance_window" {
  type        = string
  description = "Optional weekly maintenance window, for example sun:05:00-sun:09:00."
  default     = null
}

variable "subnet_group_name" {
  type        = string
  description = "Optional name for the cache subnet group."
  default     = null
}

variable "security_group_name" {
  type        = string
  description = "Optional name for the cache security group."
  default     = null
}

variable "security_group_description" {
  type        = string
  description = "Optional description for the cache security group."
  default     = "Restricted Redis ingress"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags including app, owner, data_classification, and cost_center."
  validation {
    condition     = alltrue([for key in ["app", "owner", "data_classification", "cost_center"] : contains(keys(var.tags), key)])
    error_message = "tags must include app, owner, data_classification, and cost_center."
  }
}
