resource "aws_iam_role" "tf_ec2_role" {
  name = "ec2_role"

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
  name = "ec2_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
        Effect = "Allow"
        Action = [
            "s3:*",
            "cloudwatch:*",
            "ssm:*",
            "logs:*",
            "ssmmessages:*",
            "ec2messages:*",
            "ec2:*"
        ]

        Resource = "*"
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tf_policy_attachment" {
  role = aws_iam_role.tf_ec2_role.name
  policy_arn = aws_iam_policy.tf_policy.arn
}

resource "aws_iam_role_policy_attachment" "cw_agent" {
  role       = aws_iam_role.tf_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "tf_iam_instance_profile_ec2"
  role = aws_iam_role.tf_ec2_role.name
}

resource "aws_iam_role" "tf_lambda_role" {
  name = "tf_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "tf_lambda_policy" {
  name = "tf_lambda_policy"
  role = aws_iam_role.tf_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:*",
        "s3:*"
      ]
      Resource = "*"
    }]
  })
}