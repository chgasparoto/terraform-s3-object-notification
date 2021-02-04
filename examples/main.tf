resource "aws_sns_topic" "this" {
  name   = "my-sns-test-topic"
  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": {"AWS":"*"},
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:my-sns-test-topic",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${module.bucket.arn}"}
        }
    }]
}
POLICY
}

resource "aws_sqs_queue" "queue" {
  name = "s3-event-notification-queue"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:*:*:s3-event-notification-queue",
      "Condition": {
        "ArnEquals": { "aws:SourceArn": "${module.bucket.arn}" }
      }
    }
  ]
}
POLICY
}

module "bucket" {
  source = "../"
  name   = "my-test-bucket-from-my-module-123456"

  notification_topic = [{
    topic_arn     = aws_sns_topic.this.arn
    events        = "s3:ObjectCreated:*"
    filter_suffix = ".log"
    },
    {
      topic_arn = aws_sns_topic.this.arn
      events    = "s3:ObjectRemoved:*"
  }]

  notification_queue = [{
    queue_arn     = aws_sqs_queue.queue.arn
    events        = "s3:ObjectCreated:*"
    filter_suffix = ".jpg"
  }]

  notification_lambda = [{
    lambda_function_arn = "arn:aws:lambda:us-east-2:123456789012:function:my-function:1"
    events              = "s3:ObjectCreated:*"
    filter_suffix       = ".png"
  }]
}