| Control | How the module enforces it | Checkov check ID(s) |
|---|---|---|
| Encrypt data at rest on a customer key | Sets `at_rest_encryption_enabled = true` and requires a customer-managed KMS key. | CKV_AWS_29, CKV_AWS_191 |
| Encrypt data in transit | Sets `transit_encryption_enabled = true`. | CKV_AWS_30 |
| Require authentication | Generates a 32-character AUTH token and applies it with `auth_token_update_strategy = "ROTATE"`. | CKV_AWS_31 |
| Provide resilient cache placement | Always enables Multi-AZ and automatic failover; requires at least 2 cache clusters. | CKV2_AWS_50 |
| Restrict network access | Creates a subnet group and an ingress-only SG from caller-supplied security groups or CIDRs; rejects 0.0.0.0/0 and ::/0; no egress rule. | CKV_AWS_23, CKV_AWS_24, CKV_AWS_25, CKV_AWS_260, CKV_AWS_277, CKV_AWS_382, CKV2_AWS_5 |
| Change safely | Sets `apply_immediately = false` so modifications wait for the maintenance window. | — |
| Tag consistently | Requires `app`, `owner`, `data_classification`, and `cost_center` tags on every resource. | — |
