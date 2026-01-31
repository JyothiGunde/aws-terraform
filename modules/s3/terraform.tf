resource "aws_s3_bucket" "bucket" {
  bucket = "s3-lambda-trigger-bucket-terraform"
}

resource "aws_s3_bucket_notification" "lambda_notification" {
  bucket = aws_s3_bucket.bucket.id

  lambda_function {
    lambda_function_arn = var.lambda_function
    events = ["s3:ObjectCreated:*"]
  }

  depends_on = [ var.lambda_permission ]
}