# AWS S3 Terraform module

Terraform module to handle S3 buckets, bucket objects and bucket notifications resources on AWS.

These types of resources are supported:

* [S3 Bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
* [S3 Bucket Object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object)
* [S3 Bucket Notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification)

## Usage

```hcl
module "bucket" {
  source = "github.com/chgasparoto/terraform-s3-object-notification"

  name   = "my-super-unique-bucket-name"
  acl    = "public-read"
  policy = data.template_file.s3-public-policy.rendered

  versioning = {
    enabled = true
  }

  # This property activates the module to upload the files to the bucket.
  filepath = "${path.root}/../website/build/example"
  website = {
    index_document = "index.html"
    error_document = "index.html"
  }

  logging = {
    target_bucket = module.logs.name
    target_prefix = "access/"
  }

    notification_topic = [{
    topic_arn     = aws_sns_topic.topic.arn
    events        = "s3:ObjectCreated:*"
    filter_suffix = ".log"
  }]

  notification_queue = [{
    queue_arn     = aws_sqs_queue.queue.arn
    events        = "s3:ObjectCreated:*,s3:ObjectRemoved:*"
    filter_suffix = ".jpg"
  }]

  # This property creates the needed permissions for the bucket be able to call the lambda.
  notification_lambda = [{
    lambda_function_arn = aws_lambda_function.func.arn
    events              = join(",", ["s3:ObjectCreated:*", "s3:ObjectRemoved:*])
    filter_suffix       = ".png"
  }]
}
```

## Examples

- [Simple Bucket](examples/simple-bucket)
- [Static Website](examples/static-website)
- [S3 Notifications](examples/s3-notifications)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.10 |
| aws | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
|name|Bucket unique name|`string`|`null`| ✅ |
|acl|Bucket ACL|`string`|`private`|  |
|policy|Bucket Policy|`string`||  |
|force_destroy|Whether or not to force destroy the bucket|`bool`|`false`|  |
|tags|Bucket Tags|`map(string)`|`{}`|  |
|key_prefix|Prefix to put your key(s) inside the bucket. E.g.: logs -> all files will be uploaded under logs/|`string`||  |
|filepath|The local path where the desired files will be uploaded to the bucket|`string`||  |
|versioning|Map containing versioning configuration|`map(string)`|`{}`|  |
|website|Map containing website configuration|`map(string)`|`{}`|  |
|logging|Map containing logging configuration|`map(string)`|`{}`|  |
|notification_topic|List of maps containing notification_topic configuration|`list(map(string))`|`[{}]`|  |
|notification_queue|List of maps containing notification_queue configuration|`list(map(string))`|`[{}]`|  |
|notification_lambda|List of maps containing notification_lambda configuration|`list(map(string))`|`[{}]`|  |

## Outputs

| Name | Description |
|------|-------------|
|arn|The ARN of the bucket. Will be of format `arn:aws:s3:::bucketname`|
|name|Bucket name|
|website|The website endpoint, if the bucket is configured with a website. If not, this will be an empty string|
|regional_domain_name|The bucket region-specific domain name. E.g.: `bucketname.s3.eu-central-1.amazonaws.com`|
|domain_name|The bucket domain name. Will be of format `bucketname.s3.amazonaws.com`|
|website_domain|The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records.|
|hosted_zone_id|The Route 53 Hosted Zone ID for this bucket's region|
|objects|List of objects uploaded to the bucket|
|notifications|Map of bucket notifications (lambda, queue and, topic)|

## Authors

Module managed by [Cleber Gasparoto](https://github.com/chgasparoto)

## License
[MIT](LICENSE)
