resource "random_password" "auth_token" {
  length  = 32
  special = false
}

resource "aws_elasticache_subnet_group" "this" {
  name       = var.subnet_group_name == null ? "${var.replication_group_id}-subnets" : var.subnet_group_name
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

resource "aws_security_group" "this" {
  name        = var.security_group_name == null ? "${var.replication_group_id}-redis" : var.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id
  tags        = var.tags

  dynamic "ingress" {
    for_each = var.ingress_security_group_ids
    content {
      description     = "Redis from approved security group"
      from_port       = var.port
      to_port         = var.port
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      description = "Redis from approved network"
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  lifecycle {
    precondition {
      condition     = length(var.ingress_security_group_ids) + length(var.allowed_cidr_blocks) > 0
      error_message = "Provide at least one ingress source via ingress_security_group_ids or allowed_cidr_blocks."
    }
  }
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id       = var.replication_group_id
  description                = var.description
  engine                     = "redis"
  engine_version             = var.engine_version
  node_type                  = var.node_type
  port                       = var.port
  num_cache_clusters         = var.num_cache_clusters
  parameter_group_name       = var.parameter_group_name
  maintenance_window         = var.maintenance_window
  automatic_failover_enabled = true
  multi_az_enabled           = true
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  kms_key_id                 = var.kms_key_arn
  auth_token                 = random_password.auth_token.result
  auth_token_update_strategy = "ROTATE"
  subnet_group_name          = aws_elasticache_subnet_group.this.name
  security_group_ids         = [aws_security_group.this.id]
  apply_immediately          = false
  tags                       = var.tags
}
