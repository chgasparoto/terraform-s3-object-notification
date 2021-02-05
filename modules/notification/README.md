# AWS S3 Notification Terraform module

Terraform module to handle S3 bucket notifications resources on AWS.

These types of resources are supported:

* [S3 Bucket Notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification)

## Usage

```hcl
module "bucket" {
  source = "github.com/chgasparoto/terraform-s3-object-notification/modules/notification"
  
    bucket          = aws_s3_bucket.this.bucket
    bucket_arn      = aws_s3_bucket.this.arn

    topic = [{
      topic_arn     = aws_sns_topic.topic.arn
      events        = "s3:ObjectCreated:*"
      filter_suffix = ".log"
    }]

    queue = [{
      queue_arn     = aws_sqs_queue.queue.arn
      events        = "s3:ObjectCreated:*,s3:ObjectRemoved:*"
      filter_suffix = ".jpg"
    }]

    # This property creates the needed permissions for the bucket be able to call the lambda.
    lambda_function = [{
      lambda_function_arn = aws_lambda_function.func.arn
      events              = join(",", ["s3:ObjectCreated:*", "s3:ObjectRemoved:*])
      filter_suffix       = ".png"
    }]
}
```

## Examples

- [S3 Notifications](../../examples/s3-notifications)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.10 |
| aws | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
|bucket|Bucket unique name|`string`|`null`| ✅ |
|bucket_arn|Bucket ARN|`string`|`null`| ✅ |
|topic|List of maps containing topic configuration|`list(map(string))`|`[{}]`|  |
|queue|List of maps containing queue configuration|`list(map(string))`|`[{}]`|  |
|lambda_function|List of maps containing lambda_function configuration|`list(map(string))`|`[{}]`|  |

## Outputs

| Name | Description |
|------|-------------|
|notifications|Set of notifications set on the given S3 bucket|

## Authors

Module managed by [Cleber Gasparoto](https://github.com/chgasparoto)

## License
[MIT](LICENSE)