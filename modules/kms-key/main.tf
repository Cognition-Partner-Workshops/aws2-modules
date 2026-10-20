locals {
  root_arn = "arn:aws:iam::${var.account_id}:root"
  admin_actions = [
    "kms:CancelKeyDeletion",
    "kms:Create*",
    "kms:Describe*",
    "kms:Disable*",
    "kms:Enable*",
    "kms:Get*",
    "kms:List*",
    "kms:Put*",
    "kms:Revoke*",
    "kms:ScheduleKeyDeletion",
    "kms:TagResource",
    "kms:UntagResource",
    "kms:Update*"
  ]
  user_actions = [
    "kms:Decrypt",
    "kms:DescribeKey",
    "kms:Encrypt",
    "kms:GenerateDataKey*"
  ]
  statements = concat(
    [{
      Sid       = "EnableAccountRootAdministration"
      Effect    = "Allow"
      Principal = { AWS = local.root_arn }
      Action    = "kms:*"
      Resource  = "*"
    }],
    length(var.admin_role_arns) == 0 ? [] : [{
      Sid       = "KeyAdministrators"
      Effect    = "Allow"
      Principal = { AWS = var.admin_role_arns }
      Action    = local.admin_actions
      Resource  = "*"
    }],
    length(var.user_role_arns) == 0 ? [] : [{
      Sid       = "KeyUsers"
      Effect    = "Allow"
      Principal = { AWS = var.user_role_arns }
      Action    = local.user_actions
      Resource  = "*"
    }],
    length(var.service_principals) == 0 ? [] : [{
      Sid       = "ServiceKeyUsers"
      Effect    = "Allow"
      Principal = { Service = var.service_principals }
      Action    = local.user_actions
      Resource  = "*"
    }]
  )
}

resource "aws_kms_key" "this" {
  description             = var.key_description
  enable_key_rotation     = true
  deletion_window_in_days = 30
  policy                  = jsonencode({ Version = "2012-10-17", Statement = local.statements })
  tags                    = var.tags
}

resource "aws_kms_alias" "this" {
  name          = startswith(var.alias_name, "alias/") ? var.alias_name : "alias/${var.alias_name}"
  target_key_id = aws_kms_key.this.key_id
}
