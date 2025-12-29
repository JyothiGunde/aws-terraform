output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets_id" {
  value = aws_subnet.Public.*.id
}
/*
output "private_subnets_id" {
  value = aws_subnet.private.*.id
}
*/