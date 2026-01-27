output "lambda_function" {
  value = aws_lambda_function.function.arn
}

output "lambda_permission" {
  value = aws_lambda_permission.permission.id
}