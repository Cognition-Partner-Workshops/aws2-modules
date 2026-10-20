output "function_arn" {
  value       = aws_lambda_function.this.arn
  description = "ARN of the function."
}

output "function_name" {
  value       = aws_lambda_function.this.function_name
  description = "Name of the function."
}

output "log_group_name" {
  value       = aws_cloudwatch_log_group.this.name
  description = "Name of the encrypted log group."
}
