provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_instance" "web-server" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_pair_name}"

  tags {
    Name = "web-server"
  }
}

resource "aws_security_group" "default_allow_all_sg" {
  name        = "default_allow_all_sg"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_all"
  }
}