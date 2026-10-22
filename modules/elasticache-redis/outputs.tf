output "id" {
  value       = aws_elasticache_replication_group.this.id
  description = "ID of the replication group."
}

output "arn" {
  value       = aws_elasticache_replication_group.this.arn
  description = "ARN of the replication group."
}

output "primary_endpoint_address" {
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
  description = "Primary (writer) endpoint address."
}

output "reader_endpoint_address" {
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
  description = "Reader endpoint address."
}

output "port" {
  value       = var.port
  description = "Port the cache accepts connections on."
}

output "security_group_id" {
  value       = aws_security_group.this.id
  description = "ID of the cache security group."
}

output "auth_token" {
  value       = random_password.auth_token.result
  description = "Redis AUTH token; store it in a secret, never in plain configuration."
  sensitive   = true
}
