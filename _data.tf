data "aws_s3_bucket" "selected" {
  count = var.module_enabled ? length(var.s3_bucket_ids) : 0

  bucket = var.s3_bucket_ids[count.index]
}
