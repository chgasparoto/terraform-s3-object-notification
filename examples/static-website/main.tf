locals {
  domain = "my-custom-url.com"
}

module "logs" {
  source = "github.com/chgasparoto/terraform-s3-object-notification"

  name = "${local.domain}-logs"
  acl  = "log-delivery-write"
}

module "website" {
  source = "github.com/chgasparoto/terraform-s3-object-notification"

  name = local.domain
  acl  = "public-read"

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  policy = {
    json = templatefile("policy.json", { bucket_name = local.domain })
  }

  versioning = {
    status = "Enabled"
  }

  filepath = "website"

  website = {
    index_document = "index.html"
    error_document = "index.html"
  }

  logging = {
    target_bucket = module.logs.name
    target_prefix = "access/"
  }
}

module "redirect" {
  source = "github.com/chgasparoto/terraform-s3-object-notification"

  name = "www.${local.domain}"
  acl  = "public-read"

  website = {
    redirect_all_requests_to = local.domain
  }
}
