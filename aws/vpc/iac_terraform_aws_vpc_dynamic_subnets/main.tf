provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"

}

resource "aws_vpc" "vpc" {

  cidr_block = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "${var.stack_name}-vpc"
  }
}


resource "aws_subnet" "private_subnets" {

  count = "${tonumber("${var.subnets}") > 0 ? tonumber("${var.subnets}") : 1}"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${cidrsubnet("${var.vpc_cidr_block}", 16, "${count.index}")}"
  availability_zone = "${var.availability_zones[var.aws_region][count.index]}"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "${var.stack_name}-private-subnet-${var.availability_zones[var.aws_region][count.index]}"
  }
}

resource "aws_subnet" "public_subnets" {

  count = "${tonumber("${var.subnets}") > 0 ? tonumber("${var.subnets}") : 1}"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${cidrsubnet("${var.vpc_cidr_block}", 16, "${count.index}+${var.subnets}")}"
  availability_zone = "${var.availability_zones[var.aws_region][count.index]}"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.stack_name}-public-subnet-${var.availability_zones[var.aws_region][count.index]}"
  }
}


resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name = "${var.stack_name}--internet-gateway"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = "${aws_subnet.public_subnets[0].id}"
  allocation_id = "${aws_eip.nat_gateway_eip.id}"
  tags = {
    Name = "${var.stack_name}-nat-gateway"
  }
}

resource "aws_eip" "nat_gateway_eip" {
  vpc      = true
}


resource "aws_route_table" "public_route_table" {

  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
  }

  tags = {
    Name = "${var.stack_name}-public-route-table"
  }

}

resource "aws_route_table" "private_route_table" {

  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat_gateway.id}"
  }

  tags = {
    Name = "${var.stack_name}-private-route-table"
  }

}

resource "aws_route_table_association" "public_subnets_association" {

  count = "${var.subnets ? var.subnets : 1}"
  subnet_id = "${aws_subnet.public_subnets[count.index].id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table_association" "private_subnet_1a_association" {

  count = "${var.subnets ? var.subnets : 1}"
  subnet_id = "${aws_subnet.private_subnets[count.index].id}"
  route_table_id = "${aws_route_table.private_route_table.id}"

}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

