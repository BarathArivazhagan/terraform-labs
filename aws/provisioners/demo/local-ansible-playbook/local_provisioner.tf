provider "aws" {
  region = var.aws_region
}



resource "aws_instance" "ec2_instance" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = var.subnet_id
  security_groups = [var.sg_id]

  provisioner "local-exec" {
    command = "echo ${self.private_ip} > inventory.txt "
  }
}


### Variables

variable "aws_region" {}
variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "subnet_id" {}
variable "sg_id" {}