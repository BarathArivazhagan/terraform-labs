variable "aws_region" {}

variable "aws_access_key" {
  description = "AWS access key to access AWS resources"
  default = "" # Not recommended to use access key as it leads to security issues
}


variable "aws_secret_key" {
  description = "AWS secret key to access AWS resources"
  default = "" # Not recommended to use secret key as it leads to security issues
}

variable "vpc_id" {}

variable "instance_type" {
  default = "t2.micro"
  description = "EC2 instance type to be associated"
}

variable "root_block_volume_size" {
  type="string"
  default = "8"
  description = "root volume device space to be associated with the instance"
}

variable "jenkins_sg_name" {}

variable "ami" {
  type        = "string"
  description = "AMI to be used when launching the instances"
  default     = "ami-6d1c2007"
}

variable "public_subnet_id" {
  type        = "string"
  description = "Subnet in which the instance should be launched"
  default     = "subnet-36ce867f"
}

variable "key_pair_name" {
  type = "string"
}


variable "dns_zone_id" {
  type        = "string"
  description = "DNS hosted zone ID"
  default     = "Z3B1VVYA5I0U01"
}

variable "master_lb_name" {}

variable "elb_ssl_cert" {
  type        = "string"
  description = "SSL certificate to be attached to the ELBs"

}

variable "master_record_name" {
  type        = "string"
  description = "DNS name of jenkins master"

}


