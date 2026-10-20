output "address" {
  value       = aws_db_instance.this.address
  description = "Database endpoint address."
}

output "arn" {
  value       = aws_db_instance.this.arn
  description = "ARN of the RDS instance."
}

output "security_group_id" {
  value       = aws_security_group.this.id
  description = "ID of the database security group."
}
