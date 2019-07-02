
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

variable "vpc_id"{
  description = "AWS VPC ID to be associated with the instance"
  default = ""
}

variable "subnet_id" {
  description = "subnet id within VPC network to be associated with the instance"
  default = ""
}


variable "data" {

  description = "instance_type to be associated with the instance"
  default = "t2.micro" # use t2 micro free tier as default instance type
}


variable "database_name" {
  description = "RDS database name"
}

variable "database_port" {
  type = string
  default = 3306
}

variable "database_master_username" {
  description = "RDS user name "
}

variable "database_master_password" {
  description = "RDS user password "
}

variable "db_engine" {
  default = "mysql"
}

variable "db_instance_class" {
  default = "db.t2.micro"
}
variable "db_allocated_storage" {}

variable "db_subnet_group_name" {}

variable "db_engine_version" {}

variable "stack_name" {}
