| Control | How the module enforces it | Checkov check ID(s) |
|---|---|---|
| Encrypt function configuration | Requires KMS for environment variables and the CloudWatch log group. | CKV_AWS_158, CKV_AWS_173 |
| Trace requests | Enables active X-Ray tracing. | CKV_AWS_50 |
| Handle invocation failures | Requires a Lambda dead-letter destination. | CKV_AWS_116 |
| Retain logs | Creates an encrypted log group with a retention period. | CKV_AWS_66, CKV_AWS_338 |
| Bound concurrent execution | Supports an optional reserved concurrency input. | CKV_AWS_115 |
| Isolate private service access | Supports paired private subnet and security group inputs. | CKV_AWS_117 |
| Verify signed deployments | Optionally creates a code-signing configuration in Enforce mode. | CKV_AWS_272 |
