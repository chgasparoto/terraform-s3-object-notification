resource "aws_s3_bucket" "this" {
  bucket        = var.name
  tags          = var.tags
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = var.ownership
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [
    aws_s3_bucket_ownership_controls.this,
    aws_s3_bucket_public_access_block.this
  ]

  bucket = aws_s3_bucket.this.bucket
  acl    = var.acl
}

resource "aws_s3_bucket_policy" "this" {
  count = var.policy != null ? 1 : 0

  depends_on = [
    aws_s3_bucket_acl.this,
  ]

  bucket = aws_s3_bucket.this.id
  policy = var.policy.json
}

resource "aws_s3_bucket_versioning" "this" {
  count = var.versioning.status != null ? 1 : 0

  bucket                = aws_s3_bucket.this.id
  expected_bucket_owner = lookup(var.versioning, "expected_bucket_owner", null)
  mfa                   = lookup(var.versioning, "mfa", null)

  versioning_configuration {
    status     = lookup(var.versioning, "status", null)
    mfa_delete = lookup(var.versioning, "mfa_delete", null)
  }
}

resource "aws_s3_bucket_logging" "this" {
  count = length(keys(var.logging)) > 0 ? 1 : 0

  bucket        = aws_s3_bucket.this.id
  target_bucket = lookup(var.logging, "target_bucket", null)
  target_prefix = lookup(var.logging, "target_prefix", null)
}

resource "aws_s3_bucket_website_configuration" "this" {
  count = length(keys(var.website)) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this.bucket

  dynamic "index_document" {
    for_each = lookup(var.website, "index_document", null) == null ? [] : [var.website]
    content {
      suffix = index_document.value["index_document"]
    }
  }

  dynamic "error_document" {
    for_each = lookup(var.website, "error_document", null) == null ? [] : [var.website]
    content {
      key = error_document.value["error_document"]
    }
  }

  dynamic "redirect_all_requests_to" {
    for_each = lookup(var.website, "redirect_all_requests_to", null) == null ? [] : [var.website]
    content {
      host_name = redirect_all_requests_to.value["redirect_all_requests_to"]
    }
  }
}

module "objects" {
  source = "./modules/object"

  bucket     = aws_s3_bucket.this.bucket
  filepath   = var.filepath
  key_prefix = var.key_prefix
}

module "notification" {
  source = "./modules/notification"

  bucket          = aws_s3_bucket.this.bucket
  bucket_arn      = aws_s3_bucket.this.arn
  topic           = var.notification_topic
  queue           = var.notification_queue
  lambda_function = var.notification_lambda
}
