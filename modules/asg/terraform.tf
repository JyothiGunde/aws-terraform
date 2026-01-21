data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "lt" {

  image_id               = data.aws_ami.ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.instance_sg
  user_data              = filebase64("${path.module}/script.sh")
  iam_instance_profile {
    name = var.iam_instance_profile
  }

  tags = {
    Name = "${local.common_tags.project}-lt"
  }
}

resource "aws_autoscaling_group" "asg" {
  name                = "${local.common_tags.project}-asg"
  max_size            = 5
  min_size            = 1
  desired_capacity    = 3
  force_delete        = true
  vpc_zone_identifier = var.public_subnets_id

  target_group_arns = var.lb_tg

  launch_template {
    id      = aws_launch_template.lt.id
    version = aws_launch_template.lt.latest_version
  }

  tag {
    key                 = "Name"
    value               = local.common_tags.project
    propagate_at_launch = true
  }

}