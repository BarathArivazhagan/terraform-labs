provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

# This resource block creates aws s3 bucket
resource "aws_s3_bucket" "terraform_bucket" {
  bucket = "terraform-state-bucket"
  region = "${var.aws_region}"
}

# This resource block creates aws dynamoDB table
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-lock"
  read_capacity  = 4
  write_capacity = 4
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}


# This resource block creates aws ec2 instance
resource "aws_instance" "terraform-genesis" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_pair_name}"
  vpc_security_group_ids = ["${aws_security_group.default_allow_all_sg.id}"]
  subnet_id = "${var.subnet_id}"
  user_data = "${file("user_data")}"
  tags = {
    Name = "${var.stack_name}_terraform_genesis"
  }


}

# This resource block creates aws Secutiry Group within VPC ID with the details provided
resource "aws_security_group" "default_allow_all_sg" {
  name        = "${var.stack_name}_terraform_allow_all"
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
    Name = "${var.stack_name}_terraform_allow_all"
  }
}