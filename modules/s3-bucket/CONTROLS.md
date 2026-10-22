| Control | How the module enforces it | Checkov check ID(s) |
|---|---|---|
| Block public access | Enables all four bucket public-access-block settings. | CKV_AWS_53, CKV_AWS_54, CKV_AWS_55, CKV_AWS_56, CKV2_AWS_6 |
| Encrypt with customer KMS key | Requires a KMS ARN, enables SSE-KMS and bucket keys. | CKV_AWS_19, CKV_AWS_145 |
| Version objects | Enables bucket versioning. | CKV_AWS_21 |
| Enforce bucket ownership | Sets `BucketOwnerEnforced`. | CKV2_AWS_65 |
| Require TLS and encrypted uploads | Bucket policy denies insecure transport and uploads without the selected KMS encryption headers. | — |
| Record access | Logs to the required bucket; supports a non-logging destination bucket mode. | CKV_AWS_18 |
| Apply requested lifecycle actions | Creates lifecycle configuration when rules are supplied. | CKV2_AWS_61 |
| Object Lock (opt-in) | `object_lock_enabled = true` sets the bucket-level flag at creation; `object_lock_default_retention` applies a `GOVERNANCE` or `COMPLIANCE` default retention (`days >= 1`) to every new object version after versioning is enabled. A retention rule without the flag fails the plan. The flag is never set to `false` on an existing bucket as a side effect of the default. | manual (CKV_AWS_143 only evaluates the legacy inline `object_lock_configuration` block, not the bucket flag plus `aws_s3_bucket_object_lock_configuration` used here); assert the `object_lock_enabled` output and the `aws_s3_bucket_object_lock_configuration.this[0]` rule in the plan |
