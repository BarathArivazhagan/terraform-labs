
resource "aws_vpc" "demo-vpc" {
  cidr_block = "${var.vpc_cidr_block}"
  tags = {
    Name= "${var.stack_name}-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {

  vpc_id = "${aws_vpc.demo-vpc.id}"
  cidr_block = "${cidrsubnet("${var.vpc_cidr_block}", 8, 2)}"
  availability_zone = "${var.availability_zones[var.aws_region][0]}"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.stack_name}-public-subnet-${var.availability_zones[var.aws_region][0]}"
  }
}

resource "aws_subnet" "public_subnet_2" {

  vpc_id = "${aws_vpc.demo-vpc.id}"
  cidr_block = "${cidrsubnet("${var.vpc_cidr_block}", 8, 3)}"
  availability_zone = "${var.availability_zones[var.aws_region][1]}"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.stack_name}-public-subnet-${var.availability_zones[var.aws_region][1]}"
  }
}