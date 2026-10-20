| Control | How the module enforces it | Checkov check ID(s) |
|---|---|---|
| Encrypt storage and metrics | Requires a customer KMS key for storage and Performance Insights. | CKV_AWS_16, CKV_AWS_353, CKV_AWS_354 |
| Provide resilient database placement | Always enables Multi-AZ. | CKV_AWS_157 |
| Protect availability and data | Enables deletion protection and at least 14 backup days. | CKV_AWS_133, CKV_AWS_293 |
| Restrict public access | Sets `publicly_accessible = false`. | CKV_AWS_17 |
| Use managed credentials | Enables RDS-managed master credentials without a password input. | — |
| Enable database IAM auth | Enables database IAM authentication. | CKV_AWS_161 |
| Database audit signals | Exports PostgreSQL logs and enables Enhanced Monitoring at 60-second intervals. | CKV_AWS_118, CKV_AWS_129 |
| Require SSL | Owns a PostgreSQL parameter group with `rds.force_ssl = 1`. | CKV2_AWS_69 |
| Restrict network access | Creates a subnet group and an ingress-only SG from caller-supplied VPC, subnets, and CIDRs. | — |
