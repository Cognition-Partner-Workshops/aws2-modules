# S3 bucket

Creates a versioned, KMS-encrypted S3 bucket with public-access blocks, enforced bucket ownership, access logging, lifecycle support, and transport/encryption policy controls. Lifecycle rules support expiration and current or noncurrent version transitions. S3 Object Lock (bucket flag plus a default retention rule) is available as an opt-in and is off by default.

`log_bucket_mode = true` disables access logging for a dedicated destination bucket and requires the source bucket ARNs allowed to deliver logs. Set `logging_target_prefix` to preserve the source bucket's access-log prefix and scope the destination policy. Lifecycle rules accept `current_transition_days` / `current_transition_storage_class` and `noncurrent_transition_days` / `noncurrent_transition_storage_class` pairs.

Required inputs: `bucket_name`, `kms_key_arn`, `access_log_bucket`, `tags`.

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `bucket_name` | `string` | required | Globally unique bucket name. |
| `kms_key_arn` | `string` | required | Customer-managed KMS key used for server-side encryption. |
| `access_log_bucket` | `string` | required | Bucket receiving S3 server access logs. |
| `log_bucket_mode` | `bool` | `false` | Set true for a dedicated access-log bucket that must not log to itself. |
| `logging_source_bucket_arns` | `list(string)` | `[]` | Source bucket ARNs allowed to deliver logs when this is a log destination. Required when `log_bucket_mode = true` (enforced at plan time). |
| `logging_target_prefix` | `string` | `null` | Object prefix for server access logs; defaults to `<bucket_name>/`. |
| `lifecycle_rules` | `list(object)` | `[]` | Optional expiration and transition actions for current and noncurrent object versions. |
| `object_lock_enabled` | `bool` | `false` | Enable S3 Object Lock on the bucket. See [Object Lock](#object-lock). |
| `object_lock_default_retention` | `object({ mode = string, days = number })` | `null` | Default Object Lock retention for every new object version. `mode` must be `GOVERNANCE` or `COMPLIANCE`; `days >= 1`. Requires `object_lock_enabled = true`. |
| `tags` | `map(string)` | required | Resource tags; must include `app`, `owner`, `data_classification`, and `cost_center`. |

## Outputs

| Name | Description |
|---|---|
| `bucket_name` | Name of the protected bucket. |
| `bucket_arn` | ARN of the protected bucket. |
| `object_lock_enabled` | Whether S3 Object Lock is enabled on the bucket. |

## Object Lock

```hcl
module "wire_records" {
  source              = "git::https://github.com/Cognition-Partner-Workshops/aws2-modules.git//modules/s3-bucket?ref=<tag>"
  bucket_name         = "bank-wire-records"
  kms_key_arn         = aws_kms_key.archive.arn
  access_log_bucket   = "bank-access-logs"
  object_lock_enabled = true
  object_lock_default_retention = {
    mode = "COMPLIANCE"
    days = 2555
  }
  tags = { app = "wire-archive", owner = "payments-platform", data_classification = "restricted", cost_center = "cc-4100" }
}
```

`object_lock_default_retention` creates `aws_s3_bucket_object_lock_configuration.this[0]` after `aws_s3_bucket_versioning.this`. `COMPLIANCE` mode means no principal, including the account root, can shorten or remove the retention on a locked version; choose it deliberately.

### ForceNew arguments

`object_lock_enabled` on `aws_s3_bucket` can only be set when the bucket is created. Changing it on an existing bucket forces **replacement** of the bucket and everything in it. The module therefore:

- leaves the argument unset (`null`) when `object_lock_enabled = false`, so a bucket that already has Object Lock on is never planned for replacement by the default;
- expects adopters whose raw bucket has `object_lock_enabled = true` to pass `object_lock_enabled = true` so the move below plans as a move, not a replacement.

`bucket` (`bucket_name`) is also ForceNew; keep the raw name.

### Adopting a raw bucket

```hcl
moved {
  from = aws_s3_bucket.wire_records
  to   = module.wire_records.aws_s3_bucket.this
}

moved {
  from = aws_s3_bucket_object_lock_configuration.wire_records
  to   = module.wire_records.aws_s3_bucket_object_lock_configuration.this[0]
}
```

Move the versioning, encryption, public-access-block, ownership, logging, policy and lifecycle resources the same way; the plan must show moves and in-place updates only.
