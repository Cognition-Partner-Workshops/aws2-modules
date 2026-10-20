output "key_arn" {
  value       = aws_kms_key.this.arn
  description = "ARN of the managed KMS key."
}

output "key_id" {
  value       = aws_kms_key.this.key_id
  description = "Identifier of the managed KMS key."
}
