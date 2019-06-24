provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"

}

resource "aws_vpc" "vpc" {

  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "${var.stack_name}-vpc"
  }
}


resource "aws_subnet" "private-subnet-1a" {

  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${cidrsubnet(${var.vpc_cidr}, 16, 1)}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "${var.stack_name}-private-subnet-1a"
  }
}

resource "aws_subnet" "public-subnet-1a" {

  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${cidrsubnet(${var.vpc_cidr}, 16, 2)}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.stack_name}-public-subnet-1a"
  }
}


resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.stack_name}--internet-gateway"
  }
}

resource "aws_nat_gateway" "nat-gateway" {
  subnet_id     = "${aws_subnet.public-subnet-1a.id}"
  allocation_id = "${aws_eip.nat-gateway-eip.id}"
  tags = {
    Name = "${var.stack_name}-nat-gateway"
  }
}

resource "aws_eip" "nat-gateway-eip" {
  vpc      = true
}


resource "aws_route_table" "client-public-route-table" {

  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet-gateway.id}"
  }

  tags = {
    Name = "${var.stack_name}-public-route-table"
  }

}

resource "aws_route_table" "private-route-table" {

  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat-gateway.id}"
  }

  tags = {
    Name = "${var.stack_name}-private-route-table"
  }

}

resource "aws_route_table_association" "public_subnet_1a_association" {

  subnet_id = "${aws_subnet.public-subnet-1a.id}"
  route_table_id = "${aws_route_table.client-public-route-table.id}"
}

resource "aws_route_table_association" "private_subnet_1a_association" {

  subnet_id = "${aws_subnet.private-subnet-1a.id}"
  route_table_id = "${aws_route_table.private-route-table.id}"

}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}