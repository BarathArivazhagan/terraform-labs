output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.eks_vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       =  aws_vpc.eks_vpc.cidr_block
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = aws_vpc.eks_vpc.default_security_group_id
}




output "private_subnets" {
  description = "List of IDs of private subnets"
  value       =  aws_subnet.private_subnets.*.id
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = aws_subnet.private_subnets.*.cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public_subnets.*.id
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = aws_subnet.private_subnets.*.cidr_block
}


output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.nat_gateway.id
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       =  aws_internet_gateway.internet_gateway.id
}

