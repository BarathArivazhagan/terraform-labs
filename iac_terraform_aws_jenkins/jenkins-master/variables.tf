variable "instance_type" {
  type        = "string"
  description = "Type of the EC2 instance to be launched"
  default     = "t2.micro"
}

variable "root_block_volume_size" {
  type="string"
  default = "8"
  description = "root volume device space to be associated with the instance"
}

variable "key_pair_name" {
  type        = "string"
  description = "Key pair that needs to be attached to the instance"

}

variable "ami" {
  type        = "string"
  description = "AMI to be used when launching the instances"
}

variable "public_subnet_id" {
  type        = "string"
  description = "Subnet in which the EC2 instance should be launched"
}

variable "security_group_ids" {
  type = "list"
}

variable "master_elb_name" {
  type        = "string"
  description = "ELB name for Jenkins master"
}

variable "master_elb_sg" {
  type        = "list"
  description = "Security group to be attached to the master ELB"
}

variable "master_elb_subnets" {
  type        = "list"
  description = "Subnets to be attached to the ELB"
}

variable "master_elb_ssl_cert" {
  type        = "string"
  description = "SSL certificate to be attached to the master ELB"
}

variable "ssh_key_private" {}