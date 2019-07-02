
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
    us-east-1 = ["us-east-1a","us-east-1b","us-east-1c","us-east-1d","us-east-1e","us-east-1f"]
    us-east-2 = ["us-east-2a","us-east-2b","us-east-2c"]
    us-west-1 = ["us-west-1a","us-west-1b"]
    us-west-2 = ["us-west-1a","us-west-2b"]
  }
}

variable "stack_name" {

  description = "stack name to be assoicated with all the resources created using this script"
  default = "demo"
}