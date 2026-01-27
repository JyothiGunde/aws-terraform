resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/example-lambda"
  retention_in_days = 7
}