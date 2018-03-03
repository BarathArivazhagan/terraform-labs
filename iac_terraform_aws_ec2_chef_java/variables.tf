
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

variable "key_pair_name"{
  description = "key pair to be associated with the instance"
}

variable "instance_type" {

  description = "instance_type to be associated with the instance"
  default = "t2.micro" # use t2 micro free tier as default instance type
}

variable "ami" {
  description = "ami to be associated with the instance"
  default = "ami-97785bed" # use amazon linux ami as default (Amazon Linux AMI 2017.09.1 (HVM), SSD Volume Type)
}

variable "instance_tags" {
   type = "map"
   default = {
    Name = "web-server"
  }
}

variable "chef_user_key_filepath" {}

variable "node_name" {
  description = "node name to be associated with the instance in chef server"
}

variable "chef_user_name" {
   description = "chef server user name "
}
variable "chef_server_url" {


}

variable "chef_client_private_key" {}

variable "chef_run_list" {
  type = "list"
  description = "describe the run list to be executed in the chef node instance"
}

variable "chef_environment" {
  description = "environmnet to pass for chef client run"
}

variable "ssh_connection_user" {
  description = "ssh connection user name to login to the chef node/chef client instance"
}