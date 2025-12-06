output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [for i in range(var.public_subnet_count) : aws_subnet.this[i].id]
}

output "private_subnet_ids" {
  value = [for i in range(var.private_subnet_count) : aws_subnet.this[var.public_subnet_count + i].id]
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}
