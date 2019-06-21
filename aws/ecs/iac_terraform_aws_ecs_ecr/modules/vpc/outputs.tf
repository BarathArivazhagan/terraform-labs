output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "vpc_cidr" {
  value = "${aws_vpc.vpc.cidr_block}"
}

output "igw" {
  value = "${aws_internet_gateway.internet-gateway.id}"
}

output "public_subnet_id" {
  value = "${aws_subnet.public-subnet-1a.id}"
}

output "private_subnet_id" {
  value = "${aws_subnet.private-subnet-1a.id}"
}