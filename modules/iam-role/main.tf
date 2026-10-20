resource "aws_iam_role" "this" {
  name                 = var.role_name
  permissions_boundary = var.permissions_boundary_arn
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { (var.assume_role_principal_type) = var.assume_role_principals }
      Action    = "sts:AssumeRole"
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "this" {
  count  = length(var.inline_policy_statements) > 0 ? 1 : 0
  name   = var.inline_policy_name == null ? "${var.role_name}-inline" : var.inline_policy_name
  role   = aws_iam_role.this.id
  policy = jsonencode({ Version = "2012-10-17", Statement = var.inline_policy_statements })
}
