output "key" {
  value = aws_s3_bucket_object.this.key
}

output "etag" {
  value = aws_s3_bucket_object.this.etag
}

output "content_type" {
  value = aws_s3_bucket_object.this.content_type
}
