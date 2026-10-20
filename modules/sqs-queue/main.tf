resource "aws_sqs_queue" "dead_letter" {
  name                      = "${var.queue_name}-dlq"
  message_retention_seconds = var.retention_seconds
  kms_master_key_id         = var.kms_key_arn
  tags                      = var.tags
}

resource "aws_sqs_queue" "this" {
  name                      = var.queue_name
  message_retention_seconds = var.retention_seconds
  kms_master_key_id         = var.kms_key_arn
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter.arn
    maxReceiveCount     = var.max_receive_count
  })
  tags = var.tags
}

data "aws_iam_policy_document" "queue_tls" {
  for_each = {
    main = aws_sqs_queue.this.arn
    dlq  = aws_sqs_queue.dead_letter.arn
  }
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["sqs:*"]
    resources = [each.value]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_sqs_queue_policy" "this" {
  for_each  = data.aws_iam_policy_document.queue_tls
  queue_url = each.key == "main" ? aws_sqs_queue.this.id : aws_sqs_queue.dead_letter.id
  policy    = each.value.json
}
