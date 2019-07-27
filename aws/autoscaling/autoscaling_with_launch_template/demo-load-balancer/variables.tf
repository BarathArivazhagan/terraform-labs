
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

variable "app_port" {}

variable "lb_port" {}