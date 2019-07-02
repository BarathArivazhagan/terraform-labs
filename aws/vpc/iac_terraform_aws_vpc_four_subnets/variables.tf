
variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS access key to access AWS resources"
  default = "" # Not recommended to use access key as it leads to secutiry issues
}


variable "aws_secret_key" {
  description = "AWS secret key to access AWS resources"
  default = "" # Not recommended to use secret key as it leads to secutiry issues
}

variable "vpc_cidr_block" {
  description = "vpc cidr block association"
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type = "map"
  default = {
    us-east-1 = ["a","b","c","d","e","f"]
    us-east-2 = ["a","b","c"]
    us-west-1 = ["a","b"]
    us-west-2 = ["a","b"]
  }
}

variable "stack_name" {

  description = "stack name to be assoicated with all the resources created using this script"
  default = "demo"
}