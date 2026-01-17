#instance-sg
resource "aws_security_group" "ssh_http" {
  name        = "ssh-http"
  description = "Allow ssh & http"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${local.common_tags.project}-instance-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.ssh_http.id
  cidr_ipv4         = var.cidr_block
  for_each          = var.ports
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.ssh_http.id
  cidr_ipv4         = var.cidr_block
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#lb-sg
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