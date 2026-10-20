# S3 bucket

Creates a versioned, KMS-encrypted S3 bucket with public-access blocks, enforced bucket ownership, access logging, lifecycle support, and transport/encryption policy controls. Lifecycle rules support expiration and current or noncurrent version transitions.

`log_bucket_mode = true` disables access logging for a dedicated destination bucket and requires the source bucket ARNs allowed to deliver logs. Set `logging_target_prefix` to preserve the source bucket's access-log prefix and scope the destination policy. Lifecycle rules accept `current_transition_days` / `current_transition_storage_class` and `noncurrent_transition_days` / `noncurrent_transition_storage_class` pairs.

Required inputs: `bucket_name`, `kms_key_arn`, `access_log_bucket`, `tags`.
