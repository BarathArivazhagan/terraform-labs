
variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS access key to access AWS resources"
  default = "" # Not recommended to use access key as it leads to security issues
}


variable "aws_secret_key" {
  description = "AWS secret key to access AWS resources"
  default = "" # Not recommended to use secret key as it leads to security issues
}

variable "ami" {}

variable "instance_type" {}
variable "key_pair_name" {}
variable "sg_id" {}
variable "subnet_id" {}