provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"

}

resource "aws_instance" "web-server" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_pair_name}"
  security_groups = ["${aws_security_group.default_allow_all_sg.name}"]
  subnet_id="${var.subnet_id}"
  tags {
    Name = "web-server"
  }



}

resource "aws_security_group" "default_allow_all_sg" {
  name        = "default_allow_all_sg"
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

  tags {
    Name = "default_allow_all_sg"
  }
}