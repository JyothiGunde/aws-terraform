resource "aws_lambda_permission" "permission" {
  statement_id = "AllowExecutionFromS3"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal = "s3.amazonaws.com"
  source_arn = var.s3_bucket
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.root}/lambda_src/lambda_function.py"
  output_path = "${path.root}/lambda.zip"
}

resource "aws_lambda_function" "function" {
  function_name = "s3-triggers-lambda"
  role          = var.lambda_iam_role
  runtime       = "python3.11"
  handler       = "lambda_function.lambda_handler"
  timeout       = 10

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}