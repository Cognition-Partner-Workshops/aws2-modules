# SQS queue

Creates an encrypted processing queue and dead-letter queue, configures redrive after five receives by default, and attaches TLS-only policies to both queues. Message retention defaults to 14 days.

Required inputs: `queue_name`, `kms_key_arn`, `tags`.
