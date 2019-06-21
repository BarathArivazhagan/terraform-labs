

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

variable "vpc_cidr" {
  description = "vpc cidr block association"
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "vpc name association"
  default = "client-vpc"
}

variable "aws_internet_gateway_name" {

  description = "vpc internet gateway association"
  default = "client-internet-gateway"
}


variable "public_subnet_cidr_a" {

}
variable "private_subnet_cidr_a" {

}


variable "private_client_aws_route_table" {

}
variable "public_client_aws_route_table" {

}

variable "stack_name" {

  description = "stack name to be assoicated with all the resources created using this script"
  default = "demo"
}