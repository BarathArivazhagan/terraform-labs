provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}


# This resource block creates AWS EC2 instance with the details provided
resource "aws_instance" "windows_server" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_pair_name}"
  vpc_security_group_ids = ["${aws_security_group.windows_server_security_group.id}"]
  subnet_id = "${var.subnet_id}"
  tags = {
    Name = "${var.stack_name}-windows-server"
  }
}

# This resource block creates AWS Secutiry Group within VPC ID with the details provided
resource "aws_security_group" "windows_server_security_group" {
  name        = "${var.stack_name}-windows-security-group"
  description = "Allow all inbound traffic"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.stack_name}-windows-security-group"
  }
}