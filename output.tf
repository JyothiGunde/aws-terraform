output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb" {
  value = module.asg.alb_dns
}

