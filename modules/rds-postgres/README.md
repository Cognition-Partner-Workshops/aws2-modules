# RDS PostgreSQL

Creates an encrypted, Multi-AZ PostgreSQL instance with deletion protection, managed master credentials, IAM database authentication, 14-day minimum backups, encrypted Performance Insights, SSL enforcement, and module-owned subnet and security groups.

Required inputs: `db_identifier`, `database_name`, `master_username`, `kms_key_arn`, `vpc_id`, `subnet_ids`, `allowed_cidr_blocks`, `tags`.

Optional inputs: `backup_retention_days`, `instance_class`, `subnet_group_name`, `security_group_name`, `parameter_group_name`, `monitoring_role_name`.
