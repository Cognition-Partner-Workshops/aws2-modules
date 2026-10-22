# AWS 2.0 module catalog

Reusable Terraform modules for secure AWS application infrastructure. Each module owns its baseline controls so application teams provide only the identifiers, principals, and network boundaries specific to their workload.

## Catalog

| Module | Purpose |
|---|---|
| `s3-bucket` | Versioned, encrypted S3 bucket, access logging, lifecycle, and restrictive bucket policy. |
| `kms-key` | Rotating KMS key with scoped administration and data-use permissions. |
| `iam-role` | Workload role with a required permissions boundary and validated inline policies. |
| `sqs-queue` | KMS-encrypted queue and DLQ with redrive and TLS-only policies. |
| `lambda-function` | KMS-protected Lambda function, encrypted logs, tracing, and dead-letter destination. |
| `rds-postgres` | Encrypted, Multi-AZ PostgreSQL with managed credentials and constrained networking. |
| `elasticache-redis` | Encrypted, Multi-AZ Redis replication group with a rotating AUTH token and constrained networking. |

## Usage

```hcl
module "archive" {
  source            = "git::https://github.com/Cognition-Partner-Workshops/aws2-modules.git//modules/s3-bucket?ref=v1.0.0"
  bucket_name       = "bank-wire-archive"
  kms_key_arn       = aws_kms_key.archive.arn
  access_log_bucket = "bank-access-logs"
  tags = {
    app                 = "wire-archive"
    owner               = "payments-platform"
    data_classification = "restricted"
    cost_center         = "cc-4100"
  }
}
```

On HCP Terraform the source is `app.terraform.io/<org>/<name>/aws`.

## Versioning

Released versions use semantic version tags. Pin callers to a tag, review the module changelog, and upgrade deliberately; incompatible input or behavior changes require a new major version.

## Requesting a new module or capability

Open a GitHub issue using [the module request template](.github/ISSUE_TEMPLATE/module-request.md). Include the owning application, required controls, expected inputs, and acceptance criteria.
