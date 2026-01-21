output "iam_instance_profile" {
  value = aws_iam_instance_profile.ec2.name
}

output "iam_role" {
  value = aws_iam_role.tf_role.arn
}