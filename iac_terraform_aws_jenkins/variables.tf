variable "aws_region" {}

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "vpc_id" {}

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

variable "ssh_private_key"{

}

variable "dns_zone_id" {
  type        = "string"
  description = "DNS hosted zone ID"
  default     = "Z3B1VVYA5I0U01"
}

variable "master_elb_name" {}

variable "elb_ssl_cert" {
  type        = "string"
  description = "SSL certificate to be attached to the ELBs"

}

variable "master_record_name" {
  type        = "string"
  description = "DNS name of jenkins master"

}


