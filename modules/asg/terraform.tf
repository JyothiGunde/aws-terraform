provider "aws" {
  region = var.region
}

resource "aws_security_group" "ssh_http" {
  name        = "ssh-http"
  description = "Allow ssh & http"
  vpc_id      = var.vpc

  tags = {
    Name = "ssh-http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.ssh_http.id
  cidr_ipv4         = var.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.ssh_http.id
  cidr_ipv4         = var.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.ssh_http.id
  cidr_ipv4         = var.cidr_block
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_launch_template" "lt" {
  name = "${var.project}-lt"

  image_id = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.ssh_http.id ]
  user_data = filebase64("${path.module}/script.sh")

}

resource "aws_autoscaling_group" "asg" {
  name                      = "${var.project}-asg"
  max_size                  = 4
  min_size                  = 1
  desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier       = ["subnet-0126b1640ac048482", "subnet-07c0ef33f999a3656", "subnet-0c96f88eae88330ef"]

  target_group_arns = [
    aws_lb_target_group.test.arn
  ]

   launch_template {
    id      = aws_launch_template.lt.id
    version = aws_launch_template.lt.latest_version
  }
}

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = ["subnet-0126b1640ac048482", "subnet-07c0ef33f999a3656", "subnet-0c96f88eae88330ef"]

}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "http"
  description = "Allow http"
  vpc_id      = var.vpc

  tags = {
    Name = "http"
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
