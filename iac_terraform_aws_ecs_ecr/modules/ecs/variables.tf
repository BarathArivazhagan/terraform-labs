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

variable "environment" {
  default = ""
  description = "envrionment name to be associated"
}

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


variable "public_subnet_cidr_a" {

}
variable "private_subnet_cidr_a" {

}


variable "private_client_aws_route_table" {

}
variable "public_client_aws_route_table" {

}

variable "ecr_name" {

  description = "Elastic contianer registry name"
}

variable "max_image_count" {

  default = 7
}


variable "ecs_cluster_name" {

  description = "AWS ECS cluster name to be associated"
}

variable "fargate_cpu" {}

variable "fargate_memory" {}
variable "app_image" {}

variable "container_port" {}

variable "host_port" {}

variable "app_family_name" {}

variable "container_name" {}

variable "task_count" {}

variable "user" {

  description = "user name to login through ssh connection type"
}

variable "private_key_path" {

  description = "provide the path to private key to login to the instance"
}


variable "template_source_path" {

  description = "Source path to the template"
}
variable "template_destination_path" {

  description = "Destination path to the rendered template"
}