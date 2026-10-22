resource "aws_s3_bucket" "this" {
  bucket              = var.bucket_name
  object_lock_enabled = var.object_lock_enabled ? true : null
  tags                = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "this" {
  count  = var.object_lock_default_retention == null ? 0 : 1
  bucket = aws_s3_bucket.this.id

  rule {
    default_retention {
      mode = var.object_lock_default_retention.mode
      days = var.object_lock_default_retention.days
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]

  lifecycle {
    precondition {
      condition     = var.object_lock_enabled
      error_message = "object_lock_default_retention requires object_lock_enabled = true; Object Lock can only be turned on when the bucket is created."
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_logging" "this" {
  count         = var.log_bucket_mode ? 0 : 1
  bucket        = aws_s3_bucket.this.id
  target_bucket = var.access_log_bucket
  target_prefix = var.logging_target_prefix == null ? "${var.bucket_name}/" : var.logging_target_prefix
}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.this.arn, "${aws_s3_bucket.this.arn}/*"]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  statement {
    sid    = "DenyUnencryptedUploads"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms"]
    }
  }

  statement {
    sid    = "DenyUnapprovedEncryptionKey"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = [var.kms_key_arn]
    }
  }

  dynamic "statement" {
    for_each = var.log_bucket_mode ? [true] : []
    content {
      sid    = "AllowS3AccessLogDelivery"
      effect = "Allow"
      principals {
        type        = "Service"
        identifiers = ["logging.s3.amazonaws.com"]
      }
      actions = ["s3:PutObject"]
      resources = [
        var.logging_target_prefix == null
        ? "${aws_s3_bucket.this.arn}/*"
        : "${aws_s3_bucket.this.arn}/${trimsuffix(var.logging_target_prefix, "/")}/*"
      ]
      condition {
        test     = "ArnLike"
        variable = "aws:SourceArn"
        values   = var.logging_source_bucket_arns
      }
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json

  lifecycle {
    precondition {
      condition     = !var.log_bucket_mode || length(var.logging_source_bucket_arns) > 0
      error_message = "log_bucket_mode requires at least one logging_source_bucket_arns entry."
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.enabled ? "Enabled" : "Disabled"
      filter {}
      dynamic "expiration" {
        for_each = rule.value.expiration_days == null ? [] : [rule.value.expiration_days]
        content {
          days = expiration.value
        }
      }
      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration_days == null ? [] : [rule.value.noncurrent_version_expiration_days]
        content {
          noncurrent_days = noncurrent_version_expiration.value
        }
      }
      dynamic "transition" {
        for_each = rule.value.current_transition_days == null ? [] : [rule.value.current_transition_days]
        content {
          days          = transition.value
          storage_class = rule.value.current_transition_storage_class
        }
      }
      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_transition_days == null ? [] : [rule.value.noncurrent_transition_days]
        content {
          noncurrent_days = noncurrent_version_transition.value
          storage_class   = rule.value.noncurrent_transition_storage_class
        }
      }
    }
  }
}
