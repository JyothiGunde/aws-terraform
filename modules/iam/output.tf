output "iam_instance_profile" {
  value = aws_iam_instance_profile.ec2.name
}

output "ec2_iam_role" {
  value = aws_iam_role.tf_ec2_role.arn
}

output "lambda_iam_role" {
  value = aws_iam_role.tf_lambda_role.arn
}