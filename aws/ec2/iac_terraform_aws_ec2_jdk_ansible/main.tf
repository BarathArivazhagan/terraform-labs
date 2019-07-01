provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}


# This resource block creates aws ec2 instance with the details provided
resource "aws_instance" "ec2-instance" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_pair_name}"
  vpc_security_group_ids = ["${aws_security_group.ec2_default_allow_all_sg.id}"]
  subnet_id = "${var.subnet_id}"
  tags {
    Name = "ec2-ansible-jdk"
  }

//  provisioner "file" {
//    source      = "scripts/jdk1.8_script.sh"
//    destination = "/tmp/jdk1.8_script.sh"
//  }

  # remote provisioner configuration
  provisioner "remote-exec" {

    script = "scripts/jdk1.8_script.sh"
    connection {
      type = "ssh"
      user = "${var.ssh_connection_user}"
      private_key = "${file(var.ssh_private_key)}"
    }
  }
}

# This resource block creates AWS Secutiry Group within VPC ID with the details provided
resource "aws_security_group" "ec2_default_allow_all_sg" {
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
    Name = "allow_all"
  }
}