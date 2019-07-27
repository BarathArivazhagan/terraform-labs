provider "aws" {
  region = var.aws_region

}

resource "aws_instance" "demo_instance" {

  count = var.env == "dev" ? 1 : 3
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = [var.sg_id]
  subnet_id="${var.subnet_id}"
  tags = {
    Name = "${var.stack_name}-${var.env}-web-server"
  }


}

variable "aws_region" {}
variable "ami" {}
variable "instance_type" {}
variable "sg_id" {}
variable "subnet_id" {}
variable "key_name" {}
variable "env" {}
variable "stack_name" {}