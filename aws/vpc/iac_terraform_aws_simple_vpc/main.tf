provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"

}

# resource block to create vpc
resource "aws_vpc" "vpc" {

  cidr_block = "${var.vpc_cidr_block}"
  tags = {
    Name = "${var.stack_name}-vpc"
  }
}


output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "vpc_cidr_block" {
  value = "${aws_vpc.vpc.cidr_block}"
}

