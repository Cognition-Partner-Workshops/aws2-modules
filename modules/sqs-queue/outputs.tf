output "queue_arn" {
  value       = aws_sqs_queue.this.arn
  description = "ARN of the processing queue."
}

output "queue_url" {
  value       = aws_sqs_queue.this.url
  description = "URL of the processing queue."
}

output "dead_letter_queue_arn" {
  value       = aws_sqs_queue.dead_letter.arn
  description = "ARN of the dead-letter queue."
}

output "dead_letter_queue_url" {
  value       = aws_sqs_queue.dead_letter.url
  description = "URL of the dead-letter queue."
}
