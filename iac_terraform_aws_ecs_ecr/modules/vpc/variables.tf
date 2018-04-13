variable "vpc_cidr" {
  description = "vpc cidr block association"
}

variable "vpc_name" {
  description = "vpc name association"
  default = "ecs-vpc"
}

variable "aws_internet_gateway_name" {

  description = "vpc name association"
  default = "ecs-internet-gateway"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}



variable "public_subnet_cidr_a" {

}
variable "private_subnet_cidr_a" {

}


variable "private_client_aws_route_table" {

}
variable "public_client_aws_route_table" {

}