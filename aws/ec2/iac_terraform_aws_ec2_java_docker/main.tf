provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}


# This resource block creates aws ec2 instance with the details provided
resource "aws_instance" "web-server" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_pair_name}"
  vpc_security_group_ids = ["${aws_security_group.default_allow_all_sg.id}"]
  subnet_id = "${var.subnet_id}"
  user_data = "${file("user_data")}"
  tags = {
    Name = "${var.stack_name}-ec2-docker-java"
  }

}


# This resource block creates AWS Secutiry Group within VPC ID with the details provided
resource "aws_security_group" "web_security_group" {
  name        = "${var.stack_name}_web_sg"
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
    Name = "allow_all"
  }
}

output "web-server-instance-id" {
  value = "${aws_instance.web-server.id}"
}

