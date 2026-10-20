output "role_arn" {
  value       = aws_iam_role.this.arn
  description = "ARN of the workload role."
}

output "role_name" {
  value       = aws_iam_role.this.name
  description = "Name of the workload role."
}
