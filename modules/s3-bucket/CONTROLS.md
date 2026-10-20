| Control | How the module enforces it | Checkov check ID(s) |
|---|---|---|
| Block public access | Enables all four bucket public-access-block settings. | CKV_AWS_53, CKV_AWS_54, CKV_AWS_55, CKV_AWS_56, CKV2_AWS_6 |
| Encrypt with customer KMS key | Requires a KMS ARN, enables SSE-KMS and bucket keys. | CKV_AWS_19, CKV_AWS_145 |
| Version objects | Enables bucket versioning. | CKV_AWS_21 |
| Enforce bucket ownership | Sets `BucketOwnerEnforced`. | CKV2_AWS_65 |
| Require TLS and encrypted uploads | Bucket policy denies insecure transport and uploads without the selected KMS encryption headers. | — |
| Record access | Logs to the required bucket; supports a non-logging destination bucket mode. | CKV_AWS_18 |
| Apply requested lifecycle actions | Creates lifecycle configuration when rules are supplied. | CKV2_AWS_61 |
