variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
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
  default = "ami-97785bed" # use amazon linux ami as default Amazon Linux AMI 2017.09.1 (HVM), SSD Volume Type
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

}
variable "chef_server_url" {}

variable "chef_client_private_key" {}

variable "chef_run_list" {
  type = "list"
  description = "describe the run list to be executed in the chef node instance"
}