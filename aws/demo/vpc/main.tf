
resource "aws_vpc" "demo-vpc" {
  cidr_block = "${var.cidr_block}"
}