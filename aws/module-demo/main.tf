provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

# ec2 module containing ec2 related resources
module "ec2_module" {

  source = "./ec2"
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_pair_name = "${var.key_pair_name}"
  sg_id = "${var.sg_id}"
  subnet_id = "${var.subnet_id}"

}

# vpc module containing vpc related resources
module "vpc_module" {
  source = "./vpc"
  cidr_block = "11.0.0.0.0/16"
}