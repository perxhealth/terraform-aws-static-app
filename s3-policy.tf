data "aws_iam_policy_document" "s3_policy" {
  count = var.module_enabled && var.create_oai ? length(data.aws_s3_bucket.selected) : 0

  statement {
    actions   = ["s3:GetObject"]
    resources = ["${data.aws_s3_bucket.selected[count.index].arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.default[0].iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [data.aws_s3_bucket.selected[count.index].arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.default[0].iam_arn]
    }
  }

  statement {
    sid     = "ForceSSLOnlyAccess"
    effect  = "Deny"
    actions = ["s3:*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [data.aws_s3_bucket.selected[count.index].arn, "${data.aws_s3_bucket.selected[count.index].arn}/*"]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = [false]
    }
  }
}

resource "aws_s3_bucket_policy" "oai" {
  count = var.module_enabled && var.create_oai ? length(data.aws_s3_bucket.selected) : 0

  bucket = var.s3_bucket_ids[count.index]
  policy = data.aws_iam_policy_document.s3_policy[count.index].json
}
