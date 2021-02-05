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