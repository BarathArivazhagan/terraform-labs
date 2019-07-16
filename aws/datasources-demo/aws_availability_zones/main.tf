provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

data "aws_availability_zones" "azs" {
  state = "available"
}


data "aws_subnet" "subnet" {
  availability_zone = data.aws_availability_zones.azs.names[0]
}


# This resource block creates AWS EC2 instance with the details provided
resource "aws_instance" "web_server" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_pair_name
  vpc_security_group_ids = [var.sg_id]
  availability_zone = data.aws_availability_zones.azs.names[0]
  subnet_id = data.aws_subnet.subnet.id
  tags = {
    Name = join("-",[var.stack_name,"datasource","demo"])
  }

}

output "azs" {
  value = data.aws_availability_zones.azs.names
}

output "subnet_id" {
  value = data.aws_subnet.subnet.id
}

output "subnet_az" {
  value = data.aws_subnet.subnet.availability_zone
}