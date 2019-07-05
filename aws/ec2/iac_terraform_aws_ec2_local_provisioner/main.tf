provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}


# This resource block creates aws ec2 instance with the details provided
resource "aws_instance" "ec2_instance" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_pair_name}"
  vpc_security_group_ids = ["${var.sg_id}"]
  subnet_id = "${var.subnet_id}"
  tags = {
    Name = "${var.stack_name}-ec2-instance"
  }

  provisioner "local-exec" {
    command = "./local_file"
  }

  provisioner "local-exec" {
    command = "echo ${self.id} > ec2_details.txt"
  }

}


