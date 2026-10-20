| Control | How the module enforces it | Checkov check ID(s) |
|---|---|---|
| Encrypt messages | Requires the customer-managed KMS key on both queues. | CKV_AWS_27, CKV2_AWS_73 |
| Redrive failed messages | Creates a DLQ and configures `maxReceiveCount` (default 5). | — |
| Require TLS | Denies all queue actions over insecure transport on both queues. | — |
| Deny public access | Attaches restrictive queue policies to the source and DLQ queues. | CKV_AWS_168, CKV_AWS_387 |
| Retain messages | Defaults retention to 14 days. | — |
