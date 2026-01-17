output "instance-sg" {
  value = aws_security_group.ssh_http.id
}

output "lb-sg" {
  value = aws_security_group.lb_sg.id
}