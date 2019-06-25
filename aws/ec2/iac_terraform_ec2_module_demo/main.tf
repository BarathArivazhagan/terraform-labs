provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}


module "ec2" {

  source = "./modules/ec2"
  key_pair_name = "${var.key_pair_name}"
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  stack_name = "${var.stack_name}"
  subnet_id = "${var.subnet_id}"
  vpc_id = "${var.vpc_id}"

}