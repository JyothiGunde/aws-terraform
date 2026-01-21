resource "aws_iam_role" "tf_role" {
  name = "tf_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "tf_policy" {
  name = "s3-lambda-cloudwatch-ssm_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
        Effect = "Allow"
        Action = [
            "s3:*",
            "lambda:*",
            "cloudwatch:*",
            "ssm:*",
            "ssmmessages:*",
            "ec2messages:*"
        ]

        Resource = "*"
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tf_policy_attachment" {
  role = aws_iam_role.tf_role.name
  policy_arn = aws_iam_policy.tf_policy.arn
}



