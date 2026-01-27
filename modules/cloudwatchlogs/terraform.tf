resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/s3-triggers-lambda"
  retention_in_days = 7
}