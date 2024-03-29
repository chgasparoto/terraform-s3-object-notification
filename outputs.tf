output "arn" {
  value = aws_s3_bucket.this.arn
}

output "name" {
  value = aws_s3_bucket.this.id
}

output "website" {
  value = length(keys(var.website)) > 0 ? aws_s3_bucket_website_configuration.this[0].website_endpoint : aws_s3_bucket.this.bucket_domain_name
}

output "regional_domain_name" {
  value = aws_s3_bucket.this.bucket_regional_domain_name
}

output "domain_name" {
  value = aws_s3_bucket.this.bucket_domain_name
}

output "website_domain" {
  value = length(keys(var.website)) > 0 ? aws_s3_bucket_website_configuration.this[0].website_domain : aws_s3_bucket.this.bucket_domain_name
}

output "hosted_zone_id" {
  value = aws_s3_bucket.this.hosted_zone_id
}

output "objects" {
  value = [for filename, data in module.objects : filename]
}

output "notifications" {
  value = module.notification.notification
}
