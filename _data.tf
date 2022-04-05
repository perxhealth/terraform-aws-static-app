data "aws_s3_bucket" "selected" {
  count = var.module_enabled ? length(var.s3_bucket_ids) : 0

  bucket = var.s3_bucket_ids[count.index]
}

data "aws_cloudfront_origin_access_identity" "default" {
  id = try(aws_cloudfront_origin_access_identity.default[0].id, var.oai_id)
}
