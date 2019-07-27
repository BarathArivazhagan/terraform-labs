
variable "aws_region" {
  default = "us-east-2"
}

variable "ami" {}

variable "instance_type" {}

variable "desired_capacity" {}

variable "min_size" {}

variable "max_size" {}

variable "key_name" {}

variable "name_prefix" {}

variable "stack_name" {}

variable "vpc_id" {}

variable "app_port" {
  description = "application port"
}

variable "lb_port" {
  description = "load balancer port"
}