output "lambda_function" {
  value = aws_lambda_function.tf_lambda.arn
}

output "lambda_permission" {
  value = aws_lambda_permission.permission.id
}