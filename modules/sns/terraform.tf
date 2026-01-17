resource "aws_sns_topic" "sns" {
  name = "${local.common_tags.project}-cpu"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = "jyothigunde789@gmail.com"
}