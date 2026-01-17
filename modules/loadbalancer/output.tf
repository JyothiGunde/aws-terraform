output "alb_dns" {
  value = aws_lb.alb.dns_name
}

output "tg" {
  value = aws_lb_target_group.tg.id
}