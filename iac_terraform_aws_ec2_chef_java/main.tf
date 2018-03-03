provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"


}


# This resource block creates AWS EC2 instance with the details provided
resource "aws_instance" "web-server" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_pair_name}"
  vpc_security_group_ids = ["${aws_security_group.default_allow_all_sg.id}"]
  subnet_id = "${var.subnet_id}"
  tags {
    Name = "web-server"
  }
  # chef provisioner configuration
  provisioner "chef" {
    node_name = "${var.node_name}"
    server_url = "${var.chef_server_url}"
    user_key = "${file(var.chef_user_key_filepath)}"
    user_name = "${var.chef_user_name}"
    run_list = "${var.chef_run_list}"
    environment = "${var.chef_environment}"
    recreate_client = true

    connection {
      type = "ssh"
      user = "${var.ssh_connection_user}"
      private_key = "${file(var.chef_client_private_key)}"
    }
  }
}

# This resource block creates AWS Secutiry Group within VPC ID with the details provided
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
    Name = "allow_all"
  }
}