resource "aws_db_subnet_group" "this" {
  name       = var.subnet_group_name == null ? "${var.db_identifier}-subnets" : var.subnet_group_name
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

resource "aws_security_group" "this" {
  name        = var.security_group_name == null ? "${var.db_identifier}-postgres" : var.security_group_name
  description = "Restricted PostgreSQL ingress"
  vpc_id      = var.vpc_id
  tags        = var.tags

  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      description = "PostgreSQL from approved network"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }
}

resource "aws_db_parameter_group" "this" {
  name   = var.parameter_group_name == null ? "${var.db_identifier}-postgres" : var.parameter_group_name
  family = "postgres16"
  parameter {
    name         = "rds.force_ssl"
    value        = "1"
    apply_method = "pending-reboot"
  }
  tags = var.tags
}

data "aws_iam_policy_document" "monitoring_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "monitoring" {
  name               = var.monitoring_role_name == null ? "${substr(var.db_identifier, 0, 48)}-rds-monitoring" : var.monitoring_role_name
  assume_role_policy = data.aws_iam_policy_document.monitoring_trust.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "monitoring" {
  role       = aws_iam_role.monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_db_instance" "this" {
  identifier                          = var.db_identifier
  engine                              = "postgres"
  engine_version                      = "16.3"
  instance_class                      = var.instance_class
  allocated_storage                   = 100
  max_allocated_storage               = 500
  storage_type                        = "gp3"
  storage_encrypted                   = true
  kms_key_id                          = var.kms_key_arn
  db_name                             = var.database_name
  username                            = var.master_username
  manage_master_user_password         = true
  iam_database_authentication_enabled = true
  multi_az                            = true
  deletion_protection                 = true
  backup_retention_period             = var.backup_retention_days
  performance_insights_enabled        = true
  performance_insights_kms_key_id     = var.kms_key_arn
  enabled_cloudwatch_logs_exports     = ["postgresql"]
  monitoring_interval                 = 60
  monitoring_role_arn                 = aws_iam_role.monitoring.arn
  publicly_accessible                 = false
  db_subnet_group_name                = aws_db_subnet_group.this.name
  vpc_security_group_ids              = [aws_security_group.this.id]
  parameter_group_name                = aws_db_parameter_group.this.name
  skip_final_snapshot                 = false
  final_snapshot_identifier           = "${var.db_identifier}-final"
  copy_tags_to_snapshot               = true
  tags                                = var.tags
}
