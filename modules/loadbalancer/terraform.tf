resource "aws_lb" "alb" {
  name               = "${local.common_tags.project}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.lb_sg
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