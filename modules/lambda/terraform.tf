resource "aws_lambda_function" "tf_lambda" {
  function_name = "s3-triggers-lambda"
  role = var.lambda_iam_role
  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"

  filename = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")

  timeout = 30
}

resource "aws_lambda_permission" "permission" {
  statement_id = "AllowExecutionFromS3"
  action = "lambda:Invokefunction"
  function_name = aws_lambda_function.tf_lambda.function_name
  principal = "s3.amazonaws.com"
  source_arn = var.s3_bucket
}

