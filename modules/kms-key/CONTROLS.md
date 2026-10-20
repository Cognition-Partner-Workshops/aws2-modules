| Control | How the module enforces it | Checkov check ID(s) |
|---|---|---|
| Key rotation | Enables automatic key rotation. | CKV_AWS_7 |
| Key deletion protection window | Sets a 30-day deletion window. | — |
| Scoped key policy | Grants administration and data use only to supplied principals; only account root receives `kms:*`. | CKV_AWS_33, CKV2_AWS_64 |
