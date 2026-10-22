# ElastiCache Redis

Creates an encrypted, Multi-AZ Redis replication group with automatic failover, a module-generated AUTH token applied with the `ROTATE` strategy, in-transit encryption, a customer-managed KMS key at rest, and module-owned subnet and security groups whose ingress is limited to caller-supplied security groups or network ranges.

Required inputs: `replication_group_id`, `description`, `kms_key_arn`, `vpc_id`, `subnet_ids`, `tags`, and at least one of `ingress_security_group_ids` or `allowed_cidr_blocks`.

Optional inputs: `node_type`, `engine_version`, `num_cache_clusters`, `port`, `parameter_group_name`, `maintenance_window`, `subnet_group_name`, `security_group_name`, `security_group_description`.

Outputs: `id`, `arn`, `primary_endpoint_address`, `reader_endpoint_address`, `port`, `security_group_id`, and the sensitive `auth_token`.
