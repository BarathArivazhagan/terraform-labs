provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"

}

terraform {
  backend "s3" {
    bucket = "barath-terraform-state-bucket"
    region = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }

  required_version = "0.12.2"
}


# This resource block creates aws ec2 instance
resource "aws_instance" "ec2-instance" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_pair_name}"
  vpc_security_group_ids = ["${aws_security_group.security_group.id}"]
  subnet_id = "${var.subnet_id}"
  user_data = "${file("user_data")}"
  tags = {
    Name = "${var.stack_name}-demo-ec2-instance"
  }


}

# This resource block creates AWS Secutiry Group within VPC ID with the details provided
resource "aws_security_group" "security_group" {
  name        = "${var.stack_name}-ec2-security-group"
  description = "Allow all inbound traffic"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.stack_name}-ec2-security-group"
  }
}