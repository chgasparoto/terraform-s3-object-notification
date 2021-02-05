module "bucket" {
  source = "github.com/chgasparoto/terraform-s3-object-notification"
  name   = "my-test-bucket-from-my-module-123456"

  notification_topic = [
    {
      topic_arn     = aws_sns_topic.this.arn
      events        = "s3:ObjectCreated:*"
      filter_suffix = ".log"
    },
    {
      topic_arn = aws_sns_topic.this.arn
      events    = "s3:ObjectRemoved:*"
    }
  ]

  notification_queue = [{
    queue_arn     = aws_sqs_queue.queue.arn
    events        = "s3:ObjectCreated:*"
    filter_suffix = ".jpg"
  }]

  notification_lambda = [{
    lambda_function_arn = aws_lambda_function.s3.arn
    events              = "s3:ObjectCreated:*"
    filter_suffix       = ".png"
  }]
}