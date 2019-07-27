provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

}

terraform {
  backend "s3" {
    bucket = "barath-terraform-us-east-2-state-bucket"
    region = "us-east-2"
    dynamodb_table = "terraform-state-lock"
  }

  required_version = "0.12.4"
}


# This resource block creates aws ec2 instance
resource "aws_instance" "ec2_instance" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id = var.subnet_id
  tags = {
    Name = join("-",[var.stack_name,"instance"])
  }


}

# This resource block creates AWS Secutiry Group within VPC ID with the details provided
resource "aws_security_group" "security_group" {
  name        = join("-",[var.stack_name,"ec2-security-group"])
  description = "Allow all inbound traffic"
  vpc_id = var.vpc_id
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
    Name = join("-",[var.stack_name,"ec2-security-group"])
  }
}