resource "aws_autoscaling_policy" "asg_policy" {
  name                   = "${local.common_tags.project}-cpu-70"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = var.asg_name
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
    AutoScalingGroupName = var.asg_name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.asg_policy.arn]
  ok_actions        = var.sns
}
/*
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
*/