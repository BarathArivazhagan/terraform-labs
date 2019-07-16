output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "azs" {
  value = data.aws_availability_zones.azs.names
}

output "private_subnets" {
  value = aws_subnet.private_subnets.*.id
}

output "public_subnets" {
  value = aws_subnet.public_subnets.*.id
}

output "internet-gateway-id" {
  value = aws_internet_gateway.internet_gateway.id
}

output "nat-gateway-id" {
  value = aws_nat_gateway.nat_gateway.id
}

