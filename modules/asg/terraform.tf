
resource "aws_security_group" "ssh_http" {
  name        = "ssh-http"
  description = "Allow ssh & http"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${local.common_tags.project}-instance-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id            = aws_security_group.ssh_http.id
  referenced_security_group_id = aws_security_group.lb_sg.id
  for_each                     = var.ports
  from_port                    = each.value
  ip_protocol                  = "tcp"
  to_port                      = each.value
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.ssh_http.id
  cidr_ipv4         = var.cidr_block
  ip_protocol       = "-1" # semantically equivalent to all ports
}

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
  vpc_security_group_ids = [aws_security_group.ssh_http.id]
  user_data              = filebase64("${path.module}/script.sh")
  iam_instance_profile {
    name = "CWforEC2"
  }

  tags = {
      Name = "${local.common_tags.project}-lt"
    }
  /*
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = local.common_tags.project
    }
  }
  */
}

resource "aws_autoscaling_group" "asg" {
  name                = "${local.common_tags.project}-asg"
  max_size            = 4
  min_size            = 1
  desired_capacity    = 2
  force_delete        = true
  vpc_zone_identifier = var.public_subnets_id

  target_group_arns = [
    aws_lb_target_group.tg.arn
  ]

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

resource "aws_lb" "alb" {
  name               = "${local.common_tags.project}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.public_subnets_id

}

resource "aws_lb_target_group" "tg" {
  name     = "${local.common_tags.project}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "http"
  description = "Allow http"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${local.common_tags.project}-lb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.lb_sg.id
  cidr_ipv4         = var.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.lb_sg.id
  cidr_ipv4         = var.cidr_block
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_autoscaling_policy" "asg_policy" {
  name                   = "${local.common_tags.project}-cpu-70"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_cloudwatch_metric_alarm" "cw_alarm" {
  alarm_name          = "${local.common_tags.project}-cpu-70"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.asg_policy.arn]
}
/*
resource "aws_cloudwatch_metric_alarm" "disk_alarm" {
  alarm_name                = "disk-50"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  threshold                 = 80
  alarm_description         = "This metric monitors ec2 disk utilization"

  metric_query {
    id          = "disk"
    expression  = "MAX(SEARCH('{CWAgent,InstanceId} disk_used_percent', 'Average', 60))"
    label       = "Max disk usage in ASG"
    period      = 60
    return_data = true
  }

}
*/
resource "aws_cloudwatch_metric_alarm" "disk_alarm" {
  alarm_name          = "${local.common_tags.project}-disk-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 70
  alarm_description   = "Disk usage > 80% on ASG instances"
  treat_missing_data  = "notBreaching"

  metric_name = "disk_used_percent"
  namespace   = "CWAgent"
  statistic   = "Maximum"
  period      = 60

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
    path                 = "/"
    fstype               = "xfs"
  }

  alarm_actions = [aws_sns_topic.sns.arn]
  ok_actions    = [aws_sns_topic.sns.arn]

}

resource "aws_sns_topic" "sns" {
  name = "${local.common_tags.project}-disk-70"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = "jyothigunde789@gmail.com"
}

resource "aws_cloudwatch_metric_alarm" "mem_alarm" {
  alarm_name          = "${local.common_tags.project}-memory"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 70
  alarm_description   = "Memory usage > 70% on ASG instances"
  treat_missing_data  = "notBreaching"

  metric_name = "mem_used_percent"
  namespace   = "CWAgent"
  statistic   = "Maximum"
  period      = 60

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

}