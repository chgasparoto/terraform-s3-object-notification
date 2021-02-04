resource "aws_s3_bucket_notification" "this" {
  bucket = var.bucket

  dynamic "topic" {
    for_each = length(keys(var.topic)) == 0 ? [] : [var.topic]
    content {
      id            = lookup(topic.value, "id", null)
      topic_arn     = lookup(topic.value, "topic_arn", null)
      events        = lookup(topic.value, "events", null)
      filter_prefix = lookup(topic.value, "filter_prefix", null)
      filter_suffix = lookup(topic.value, "events", null)
    }
  }

  dynamic "queue" {
    for_each = length(keys(var.queue)) == 0 ? [] : [var.queue]
    content {
      id            = lookup(queue.value, "id", null)
      queue_arn     = lookup(queue.value, "queue_arn", null)
      events        = lookup(queue.value, "events", null)
      filter_prefix = lookup(queue.value, "filter_prefix", null)
      filter_suffix = lookup(queue.value, "events", null)
    }
  }

  dynamic "lambda_function" {
    for_each = length(keys(var.lambda_function)) == 0 ? [] : [var.lambda_function]
    content {
      id                  = lookup(lambda_function.value, "id", null)
      lambda_function_arn = lookup(lambda_function.value, "lambda_function_arn", null)
      events              = lookup(lambda_function.value, "events", null)
      filter_prefix       = lookup(lambda_function.value, "filter_prefix", null)
      filter_suffix       = lookup(lambda_function.value, "events", null)
    }
  }
}

resource "aws_lambda_permission" "this" {
  for_each = length(keys(var.lambda_function)) == 0 ? [] : [var.lambda_function]

  statement_id  = "AllowExecutionFromS3Bucket${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = lookup(each.value, "lambda_function_arn", null)
  principal     = "s3.amazonaws.com"
  source_arn    = var.bucket
}
